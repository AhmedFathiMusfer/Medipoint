import 'dart:developer';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/appointment/appointmentDetails/cubit/appointment_details.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  final int appointmentId;
  final String doctorId;
  AppDatabase db = AppDatabase();

  AppointmentDetailsCubit({required this.appointmentId, required this.doctorId})
    : super(const AppointmentDetailsState.initial());
  Future<void> loadSharedFolders() async {
    emit(const AppointmentDetailsState.loading());
    try {
      final sharedFolders = await _getSharedFoldersForAppointment();
      final folderIds = sharedFolders.map((s) => s.folderId).toList();
      List<PatientFolder> folderDetails = [];
      if (folderIds.isNotEmpty) {
        folderDetails = await _getFolderDetails(folderIds);
      }

      if (!isClosed) {
        emit(
          AppointmentDetailsState.success(
            sharedFolders: sharedFolders,
            folderDetails: folderDetails,
          ),
        );
      }
    } catch (e) {
      log('Error loading shared folders: $e');
      if (!isClosed) {
        emit(
          AppointmentDetailsState.error(
            message: ErrorMessages.instance.fromExceptionType(
              ExceptionTypes.unexpected,
            ),
          ),
        );
      }
    }
  }

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
        // إعادة تحميل البيانات
        await loadSharedFolders();
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
      },
    );
    return success;
  }

  // ******************** Database Operations ********************

  Future<List<PatientSharedFolder>> _getSharedFoldersForAppointment() async {
    return await (db.select(db.patientSharedFolders)
      ..where((tbl) => tbl.appointmentId.equals(appointmentId))).get();
  }

  Future<List<PatientFolder>> _getFolderDetails(List<int> folderIds) async {
    return await (db.select(db.patientFolders)
      ..where((tbl) => tbl.id.isIn(folderIds))).get();
  }

  Future<void> _deleteSharedFolder(int id) async {
    await (db.delete(db.patientSharedFolders)
      ..where((tbl) => tbl.id.equals(id))).go();
  }
}
