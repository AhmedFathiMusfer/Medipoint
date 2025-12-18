import 'dart:developer';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/recordFiles/Folders/cubit/folder.state.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderCubit extends Cubit<FolderState> {
  FolderCubit() : super(FolderState.initial());
  AppDatabase db = AppDatabase();
  Future<void> loadAll() async {
    emit(FolderState.loading());
    await loadLocalData();
    await loadOnlineData();
  }

  Future<void> loadLocalData() async {
    try {
      final results = await Future.wait([getFolder()]);

      final folders = results[0];
      if (!isClosed) {
        emit(FolderState.success(folders: folders));
      }
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  Future<void> loadOnlineData() async {
    try {
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await Future.wait([fetchFolders()]);
      } else {
        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
      }
      await loadLocalData();
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  fillterFolderByName(String name) async {
    final filteredFolders = await getFolder(name: name);
    state.mapOrNull(
      success: (state) {
        if (!isClosed) {
          emit(state.copyWith(folders: filteredFolders));
        }
      },
    );
  }
  // ******************************************Api************************************************************

  createNewFolder(String name, String description) async {
    bool isConnected = await NetworkHelper.isConnected();
    if (isConnected) {
      await RemoteProvider().send(
        request: Request(
          url: ApiConstants.foldersEndpoint,
          body: {"name": name, "description": description},
        ),
        method: RemoteMethod.post,
        onSuccess: (res, statsCode) async {
          try {
            if (res.data != null) {
              await insertFolder(res.data);
            }
            await loadLocalData();
          } catch (ex) {
            AppSnackBar.error(
              ErrorMessages.instance.fromExceptionType(
                ExceptionTypes.unexpected,
              ),
            );
          }
        },
        onError: (_, statsCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
        },
      );
    } else {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
    }
  }

  Future<void> fetchFolders() async {
    await RemoteProvider().send(
      request: Request(url: ApiConstants.foldersEndpoint),
      method: RemoteMethod.get,
      onSuccess: (res, statsCode) async {
        try {
          if (res.data['results'].isNotEmpty) {
            await insertFolders(res.data['results']);
          }
        } catch (ex) {
          log(ex.toString());
          AppSnackBar.error(
            ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
          );
        }
      },
      onError: (_, statsCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
      },
    );
  }

  // ******************************************db************************************************************
  Future<List<PatientFolder>> getFolder({String? name}) async {
    if (name == null || name.isEmpty) {
      return await db.select(db.patientFolders).get();
    }
    return await (db.select(db.patientFolders)
      ..where((f) => f.name.contains(name))).get();
  }

  insertFolder(folder) async {
    folder['createdAt'] = folder['created_at'];
    folder['updatedAt'] = folder['updated_at'];

    await db.into(db.patientFolders).insert(PatientFolder.fromJson(folder));
  }

  insertFolders(data) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.patientFolders,
        data.map<PatientFolder>((folder) {
          folder['createdAt'] = folder['created_at'];
          folder['updatedAt'] = folder['updated_at'];

          return PatientFolder.fromJson(folder);
        }).toList(),
      );
    });
  }
}
