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
import 'package:diagno_bot/features/recordFiles/files/cubit/fileUpload.state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileCubit extends Cubit<FileState> {
  final int folderId;
  FileCubit({required this.folderId}) : super(FileState.initial());
  AppDatabase db = AppDatabase();
  Future<void> loadAll() async {
    if (!isClosed) {
      emit(FileState.loading());
    }
    await loadLocalData();
    await loadOnlineData();
  }

  Future<void> loadLocalData() async {
    try {
      final files =
          await (db.select(db.patientFiles)
            ..where((t) => t.folderId.equals(folderId))).get();

      if (!isClosed) {
        emit(FileState.success(files: files));
      }
    } catch (e) {
      //log(e.toString());
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

  fillterFolderByName(String? specialty) async {}
  // ******************************************Api************************************************************
  createNewFile(String name, String filePath) async {
    bool isConnected = await NetworkHelper.isConnected();
    if (isConnected) {
      FormData data = FormData.fromMap({
        'name': name,
        'folder': folderId,
        'file': await MultipartFile.fromFile(filePath, filename: name),
      });
      await RemoteProvider().send(
        request: Request(
          url: ApiConstants.filesEndpoint(folderId),
          body: data,
          header: {"Content-Type": "multipart/form-data"},
        ),
        method: RemoteMethod.post,
        onSuccess: (res, statsCode) async {
          try {
            if (res.data != null) {
              await insertFile(res.data, filePath);
            }
            AppSnackBar.success("the file is created");
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

  // Future<void> uploadFile(String name, String path, String type) async {
  //   // final id = UniqueKey().ro; // مؤقت لتحديد الملف
  //   emit(
  //     state.mapOrNull(
  //       success:
  //           (s) => state.copyWith(
  //             uploads: {...?s.uploads, id: FileUploadStatus.uploading(0)},
  //             files: [
  //               ...s.files,
  //               PatientFile(
  //                 id: 1,
  //                 name: name,
  //                 file: path,
  //                 folderId: folderId,
  //                 createdAt: "",
  //                 updatedAt: "",
  //               ),
  //             ],
  //           ),
  //     ),
  //   );

  //   try {
  //     bool connected = await NetworkHelper.isConnected();
  //     if (!connected) throw Exception("No connection");

  //     await RemoteProvider().send(
  //       request: Request(
  //         url: ApiConstants.filesEndpoint(folderId),
  //         body: FormData.fromMap({
  //           'name': name,
  //           'folder': folderId,
  //           'file': MultipartFile.fromFile(path, filename: name),
  //         }),
  //       ),
  //       method: RemoteMethod.post,
  //       onSendProgress: (sent, total) {
  //         final progress = sent / total;
  //         emit(
  //           state.mapOrNull(
  //             success:
  //                 (s) => state.copyWith(
  //                   uploads: {
  //                     ...?s.uploads,
  //                     id: FileUploadStatus.uploading(progress),
  //                   },
  //                 ),
  //           ),
  //         );
  //       },
  //       onSuccess: (res, _) {
  //         emit(
  //           state.mapOrNull(
  //             success:
  //                 (s) => state.copyWith(
  //                   uploads: {...?s.uploads, id: FileUploadStatus.success()},
  //                 ),
  //           ),
  //         );
  //       },
  //       onError: (_, __) {
  //         emit(
  //           state.mapOrNull(
  //             success:
  //                 (s) => state.copyWith(
  //                   uploads: {...?s.uploads, id: FileUploadStatus.failed()},
  //                 ),
  //           ),
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     emit(
  //       state.mapOrNull(
  //         success:
  //             (s) => state.copyWith(
  //               uploads: {...?s.uploads, id: FileUploadStatus.failed()},
  //             ),
  //       ),
  //     );
  //   }
  // }

  // ******************************************db************************************************************
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
