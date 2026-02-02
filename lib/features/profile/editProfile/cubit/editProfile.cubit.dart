import 'dart:developer';
import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/profile/editProfile/cubit/editProfile.state.dart';
import 'package:diagno_bot/features/profile/editProfile/form/editProfile.form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileState.initial());

  late EditProfileForm form = EditProfileForm(user: AuthManager().currentUser!);
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500,
      );
      if (image == null) return;
      var filePath = image.path;
      form.imagePath = filePath;
      emit(EditProfileState.changeProfileImage(imagePath: filePath));
    } on PlatformException catch (e) {
      // print('Failed to pick a photo $e');
    }
  }

  save() async {
    if (form.key.currentState!.validate()) {
      emit(EditProfileState.loading(loading: true));
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        var data = await form.data;

        await RemoteProvider().send(
          request: Request(url: ApiConstants.profileEndpoint, body: data),
          method: RemoteMethod.put,
          onSuccess: (res, statsCode) async {
            await AuthManager().setUser(res.data);
            emit(EditProfileState.success());
          },
          onError: (_, statsCode) {
            emit(EditProfileState.loading(loading: false));
            if (statsCode == 400) {
              AppSnackBar.error('error_invalid_data_entry'.tr());
            } else {
              AppSnackBar.error(
                ErrorMessages.instance.fromExceptionType(
                  ExceptionTypes.unexpected,
                ),
              );
            }
          },
        );
      } else {
        emit(EditProfileState.loading(loading: false));
        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
      }
    }
  }
}
