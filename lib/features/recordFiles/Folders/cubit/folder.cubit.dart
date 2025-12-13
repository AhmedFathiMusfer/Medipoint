import 'dart:developer';

import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/patient_folders_tables.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/recordFiles/Folders/cubit/folder.state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderCubit extends Cubit<FolderState> {
  FolderCubit() : super(FolderState.initial());
  AppDatabase db = AppDatabase();
  Future<void> loadAll() async {
    if (!isClosed) {
      emit(FolderState.loading());
    }
    await loadLocalData();
    await loadOnlineData();
  }

  Future<void> loadLocalData() async {
    try {
      final results = await Future.wait([db.select(db.patientFolders).get()]);

      final folders = results[0];
      if (!isClosed) {
        emit(FolderState.success(folders: folders));
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
          fetchFolders();
          // AppSnackBar.success("the folder is created");
          // try {
          //   if (res.data['results'].isNotEmpty) {
          //     await insertFolders(res.data['results']);
          //   }
          // } catch (ex) {
          //   AppSnackBar.error(
          //     ErrorMessages.instance.fromExceptionType(
          //       ExceptionTypes.unexpected,
          //     ),
          //   );
          // }
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

  fillterFolderByName(String? specialty) async {
    // final filteredDoctors = await getDoctors(specialty: specialty);
    // state.mapOrNull(
    //   success: (state) {
    //     if (!isClosed) {
    //       emit(
    //         state.copyWith(
    //           doctors: filteredDoctors,
    //           specialtySelected: specialty ?? 'All',
    //         ),
    //       );
    //     }
    //   },
    // );
  }
  // ******************************************Api************************************************************

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
