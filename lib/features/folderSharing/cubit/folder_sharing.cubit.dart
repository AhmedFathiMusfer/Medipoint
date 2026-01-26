import 'dart:developer';
import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/patient_shared_folders_tables.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/folderSharing/cubit/folder_sharing.state.dart';
import 'package:drift/drift.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderSharingCubit extends Cubit<FolderSharingState> {
  FolderSharingCubit() : super(const FolderSharingState.initial());
  AppDatabase db = AppDatabase();

  Future<void> loadDoctors() async {
    emit(const FolderSharingState.loading());
    try {
      final doctors = await _getDoctorsFromDb();
      if (!isClosed) {
        emit(FolderSharingState.doctorsLoaded(doctors: doctors));
      }
    } catch (e) {
      log('Error loading doctors: $e');
      if (!isClosed) {
        emit(
          FolderSharingState.error(
            message: ErrorMessages.instance.fromExceptionType(
              ExceptionTypes.unexpected,
            ),
          ),
        );
      }
    }
  }

  Future<void> loadFolders() async {
    emit(const FolderSharingState.loading());
    try {
      final folders = await _getFoldersFromDb();
      if (!isClosed) {
        emit(FolderSharingState.foldersLoaded(folders: folders));
      }
    } catch (e) {
      log('Error loading folders: $e');
      if (!isClosed) {
        emit(
          FolderSharingState.error(
            message: ErrorMessages.instance.fromExceptionType(
              ExceptionTypes.unexpected,
            ),
          ),
        );
      }
    }
  }

  Future<bool> shareFolderWithDoctor({
    required int folderId,
    required String doctorId,
  }) async {
    bool isConnected = await NetworkHelper.isConnected();
    if (!isConnected) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
      return false;
    }
    Map<String, Object?> data = {
      "folder_ids": [folderId],
      "doctor_id": doctorId,
      "sharing_type": "DOCTOR",
    };
    bool success = false;
    await RemoteProvider().send(
      request: Request(url: ApiConstants.shareFolderEndpoint, body: data),
      method: RemoteMethod.post,
      onSuccess: (res, statusCode) async {
        try {
          log(res.data['created_ids']?.first.toString() ?? 'no id');
          data['id'] = res.data['created_ids']?.first;
          log(data.toString());
          await _insertSharedFolder(data);
          AppSnackBar.success("folder_shared_successfully".tr());
          success = true;
        } catch (ex) {
          log('Error sharing folder: $ex');
          AppSnackBar.error(
            ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
          );
        }
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
      },
    );
    return success;
  }

  Future<bool> shareFolderViaAppointment({
    required int folderId,
    required String doctorId,
    required int appointmentId,
  }) async {
    bool isConnected = await NetworkHelper.isConnected();
    if (!isConnected) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
      return false;
    }
    Map<String, Object?> data = {
      "doctor_id": doctorId,
      "folder_ids": [folderId],
      "sharing_type": "APPOINTMENT",
      "appointment_id": appointmentId,
    };
    bool success = false;
    await RemoteProvider().send(
      request: Request(url: ApiConstants.shareFolderEndpoint, body: data),
      method: RemoteMethod.post,
      onSuccess: (res, statusCode) async {
        try {
          data['id'] = res.data['created_ids']?.first;
          await _insertSharedFolder(data);
          AppSnackBar.success("folder_shared_successfully".tr());
          success = true;
        } catch (ex) {
          log('Error sharing folder: $ex');
          AppSnackBar.error(
            ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
          );
        }
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
      },
    );
    return success;
  }

  /// إلغاء مشاركة مجلد
  Future<bool> unshareFolder(int shareId) async {
    bool isConnected = await NetworkHelper.isConnected();
    if (!isConnected) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
      return false;
    }

    bool success = false;
    await RemoteProvider().send(
      request: Request(
        url: ApiConstants.unshareFolderEndpoint,
        body: {
          "shared_ids": [shareId],
        },
      ),
      method: RemoteMethod.delete,
      onSuccess: (_, statusCode) async {
        await _deleteSharedFolder(shareId);
        AppSnackBar.success("folder_unshared_successfully".tr());
        success = true;
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
      },
    );
    return success;
  }

  // ******************** Database Operations ********************

  Future<List<DoctorModel>> _getDoctorsFromDb() async {
    final result =
        await (db.select(db.doctors).join([
          innerJoin(db.users, db.users.id.equalsExp(db.doctors.userId)),
        ])).get();

    final jsonList =
        result.map((row) {
          final doctor = row.readTable(db.doctors).toJson();
          final user = row.readTable(db.users).toJson();
          doctor['status'] = DoctorModelStatusConverter().toJson(
            doctor['status'],
          );
          return {...doctor, ...user};
        }).toList();

    return jsonList
        .map<DoctorModel>((data) => DoctorModel.fromJson(data))
        .toList();
  }

  Future<List<PatientFolder>> _getFoldersFromDb() async {
    return await db.select(db.patientFolders).get();
  }

  Future<void> _insertSharedFolder(Map<String, Object?> data) async {
    data['createdAt'] = DateTime.now().toIso8601String();
    data['sharingType'] = data['sharing_type'];
    data['patientId'] = data['patient_id'] ?? AuthManager().currentUser!.id;
    data['doctorId'] = data['doctor_id'];
    data['folderId'] = List.from(data['folder_ids'] as Iterable).toList().first;
    data['appointmentId'] = data['appointment_id'];
    log(data.toString());
    await db
        .into(db.patientSharedFolders)
        .insert(
          PatientSharedFoldersCompanion(
            id: Value(data['id'] as int),
            patientId: Value(AuthManager().currentUser!.id),
            doctorId: Value(data['doctorId'] as String),
            folderId: Value(data['folderId'] as int),
            appointmentId:
                data['appointmentId'] == null
                    ? const Value.absent()
                    : Value(data['appointmentId'] as int),
            sharingType: Value(
              const SharingTypeConverter().fromSql(
                data['sharingType'] as String,
              ),
            ),
            createdAt: Value(
              data['createdAt'] as String? ?? DateTime.now().toIso8601String(),
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> _deleteSharedFolder(int id) async {
    await (db.delete(db.patientSharedFolders)
      ..where((tbl) => tbl.id.equals(id))).go();
  }
}
