import 'dart:developer';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/recordFiles/files/cubit/file.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileCubit extends Cubit<FileState> {
  final int folderId;
  FileCubit({required this.folderId}) : super(FileState.initial());
  AppDatabase db = AppDatabase();
  Future<void> loadAll() async {
    if (!isClosed) {
      emit(FileState.loading());
    }
    if (await getFileLenght() == 0) {
      await loadOnlineData();
    } else {
      await loadLocalData();
      await loadOnlineData();
    }
  }

  Future<void> loadLocalData() async {
    try {
      final files = await getFiles();

      if (!isClosed) {
        emit(FileState.success(files: files.reversed.toList()));
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
        await Future.wait([fetchFiles(folderId)]);
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

  fillterFileByName(String name) async {
    final filteredFiles = await getFiles(name: name);
    state.mapOrNull(
      success: (state) {
        if (!isClosed) {
          emit(state.copyWith(files: filteredFiles));
        }
      },
    );
  }

  // ******************************************Api************************************************************
  createNewFile(String name, String filePath) async {
    bool isConnected = await NetworkHelper.isConnected();
    if (isConnected) {
      final extension = filePath.lastIndexOf('.');
      FormData data = FormData.fromMap({
        'name': name,
        'folder': folderId,
        'file': await MultipartFile.fromFile(filePath),
      });
      state.mapOrNull(
        success: (s) {
          emit(s.copyWith(uploadProgress: 0));
        },
      );
      await RemoteProvider().send(
        request: Request(
          url: ApiConstants.filesEndpoint(folderId),
          body: data,
          header: {"Content-Type": "multipart/form-data"},
        ),
        method: RemoteMethod.post,
        onSuccess: (res, statsCode) async {
          try {
            state.mapOrNull(
              success: (s) {
                emit(s.copyWith(uploadProgress: null));
              },
            );
            if (res.data != null) {
              await insertFile(res.data, filePath);
            }
            AppSnackBar.success("success_file_created".tr());
            await loadLocalData();
          } catch (ex) {
            AppSnackBar.error(
              ErrorMessages.instance.fromExceptionType(
                ExceptionTypes.unexpected,
              ),
            );
          }
        },
        onSendProgress: (sent, total) {
          final progress = total == 0 ? 0 : (sent / total);
          state.mapOrNull(
            success: (s) {
              emit(s.copyWith(uploadProgress: progress.toDouble()));
            },
          );
        },
        onError: (_, statsCode) {
          state.mapOrNull(
            success: (s) {
              emit(s.copyWith(uploadProgress: null));
            },
          );
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
        },
      );
    } else {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
    }
  }

  Future<void> deleteFile(PatientFile file) async {
    try {
      final isConnected = await NetworkHelper.isConnected();
      if (!isConnected) {
        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
        return;
      }

      await RemoteProvider().send(
        request: Request(url: ApiConstants.fileDeleteEndpoint(file.id)),
        method: RemoteMethod.delete,
        onSuccess: (_, __) async {
          try {
            await (db.delete(db.patientFiles)
              ..where((t) => t.id.equals(file.id))).go();

            AppSnackBar.success("file_deleted".tr());
            await loadLocalData();
          } catch (e) {
            log(e.toString());
          }
        },
        onError: (_, statusCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
        },
      );
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  Future<void> renameFile(PatientFile file, String newName) async {
    try {
      await RemoteProvider().send(
        request: Request(
          url: ApiConstants.fileUpdateEndpoint(file.id),
          body: {'name': newName, 'folder': folderId},
        ),
        method: RemoteMethod.put,
        onSuccess: (_, __) async {
          await (db.update(db.patientFiles)..where(
            (t) => t.id.equals(file.id),
          )).write(PatientFilesCompanion(name: Value(newName)));

          AppSnackBar.success("file_renamed".tr());
          await loadLocalData();
        },
        onError: (_, statusCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statusCode));
        },
      );
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  Future<void> downloadFile(PatientFile file) async {
    try {
      final isConnected = await NetworkHelper.isConnected();
      if (!isConnected) {
        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
        return;
      }
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/${file.name}';

      final currentState = state;
      currentState.maybeMap(
        orElse: () {},
        success: (s) {
          emit(
            s.copyWith(downloadsProgress: {...s.downloadsProgress, file.id: 0}),
          );
        },
      );

      var response = await RemoteProvider().download(
        url: file.file,
        savePath: savePath,
        onReceiveProgress: (received, total) {
          state.mapOrNull(
            success: (s) {
              emit(
                s.copyWith(
                  downloadsProgress: {
                    ...s.downloadsProgress,
                    file.id: total == 0 ? 0 : received / total,
                  },
                ),
              );
            },
          );
        },
      );
      if (response.statusCode == 200) {
        await (db.update(db.patientFiles)..where(
          (t) => t.id.equals(file.id),
        )).write(PatientFilesCompanion(localPath: Value(savePath)));

        state.mapOrNull(
          success: (s) {
            final updated = Map<int, double>.from(s.downloadsProgress)
              ..remove(file.id);
            emit(s.copyWith(downloadsProgress: updated));
          },
        );
      }

      await loadLocalData();
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
      );
    }
  }

  Future<void> shareFile(PatientFile file) async {
    if (file.localPath == null) {
      AppSnackBar.error("file_not_downloaded".tr());
      return;
    }

    await Share.shareXFiles([XFile(file.localPath!)], text: file.name);
  }

  Future<void> fetchFiles(int folderId) async {
    await RemoteProvider().send(
      request: Request(url: ApiConstants.filesEndpoint(folderId)),
      method: RemoteMethod.get,
      onSuccess: (res, statsCode) async {
        try {
          if (res.data['results'].isNotEmpty) {
            await insertFiles(res.data['results']);
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
  Future<List<PatientFile>> getFiles({String? name}) async {
    if (name == null || name.isEmpty) {
      return await (db.select(db.patientFiles)
        ..where((t) => t.folderId.equals(folderId))).get();
    }
    return await (db.select(db.patientFiles)
          ..where((t) => t.folderId.equals(folderId))
          ..where((f) => f.name.contains(name)))
        .get();
  }

  Future<int> getFileLenght() async {
    return (await (db.select(db.patientFiles)
          ..where((t) => t.folderId.equals(folderId))).get())
        .length;
  }

  insertFile(file, String localPath) async {
    file['createdAt'] = file['created_at'];
    file['updatedAt'] = file['updated_at'];
    file['folderId'] = file['folder'];
    file['localPath'] = localPath;
    await db.into(db.patientFiles).insert(PatientFile.fromJson(file));
  }

  insertFiles(data) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.patientFiles,
        data.map<PatientFile>((file) {
          file['createdAt'] = file['created_at'];
          file['updatedAt'] = file['updated_at'];
          file['folderId'] = file['folder'];

          return PatientFile.fromJson(file);
        }).toList(),
      );
    });
  }
}
