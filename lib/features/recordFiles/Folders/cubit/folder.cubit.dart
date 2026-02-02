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
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderCubit extends Cubit<FolderState> {
  FolderCubit() : super(FolderState.initial());
  AppDatabase db = AppDatabase();
  Future<void> loadAll() async {
    if (!isClosed) {
      emit(FolderState.loading());
    }

    if (await getFolderLength() == 0) {
      await loadOnlineData();
    } else {
      await loadLocalData();
      await loadOnlineData();
    }
  }

  Future<void> loadLocalData() async {
    try {
      final results = await Future.wait([getFolder()]);

      final folders = results[0].reversed.toList();
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
              AppSnackBar.success("foder_Created".tr());
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

  Future<void> renameFolder({
    required int id,
    required String name,
    required String description,
  }) async {
    bool isConnected = await NetworkHelper.isConnected();

    if (!isConnected) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
      return;
    }

    await RemoteProvider().send(
      request: Request(
        url: "${ApiConstants.foldersEndpoint}$id/",
        body: {"name": name, "description": description},
      ),
      method: RemoteMethod.put,
      onSuccess: (res, statusCode) async {
        if (res.data != null) {
          await updateFolderInDb(res.data);
          AppSnackBar.success("folder_updated".tr());
        }
        await loadLocalData();
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
      },
    );
  }

  Future<void> deleteFolder(int id) async {
    bool isConnected = await NetworkHelper.isConnected();

    if (!isConnected) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
      return;
    }

    await RemoteProvider().send(
      request: Request(url: "${ApiConstants.foldersEndpoint}$id/"),
      method: RemoteMethod.delete,
      onSuccess: (_, statusCode) async {
        await deleteFolderFromDb(id);
        AppSnackBar.success("folder_deleted".tr());
        await loadLocalData();
      },
      onError: (_, statusCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
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

  Future<int> getFolderLength() async {
    return (await (db.select(db.patientFolders)).get()).length;
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

  Future<void> updateFolderInDb(Map<String, dynamic> folder) async {
    folder['createdAt'] = folder['created_at'];
    folder['updatedAt'] = folder['updated_at'];

    await db
        .into(db.patientFolders)
        .insertOnConflictUpdate(PatientFolder.fromJson(folder));
  }

  Future<void> deleteFolderFromDb(int id) async {
    await (db.delete(db.patientFolders)
      ..where((tbl) => tbl.id.equals(id))).go();
    await (db.delete(db.patientFiles)
      ..where((f) => f.folderId.equals(id))).go();
  }
}
