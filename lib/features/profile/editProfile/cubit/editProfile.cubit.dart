import 'dart:developer';

import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/profile/editProfile/cubit/editProfile.state.dart';
import 'package:diagno_bot/features/profile/editProfile/form/editProfile.form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final String? newImagePath;
  EditProfileCubit(this.newImagePath) : super(EditProfileState.initial());
  late EditProfileForm form = EditProfileForm(
    user: AuthManager().currentUser!,
    newImagePath: newImagePath,
  );

  save() async {
    if (form.key.currentState!.validate()) {
      // emit(LoginState.initial(loading: true));
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await RemoteProvider().send(
          request: Request(url: ApiConstants.profileEndpoint, body: form.body),
          method: RemoteMethod.put,
          onSuccess: (res, statsCode) async {
            log(res.toString());
            await AuthManager().setToken(res.data);
            //  emit(LoginState.loginSuccess());
          },
          onError: (_, statsCode) {
            if (statsCode == 400) {
              AppSnackBar.error('the data entry is inValid');
              // emit(LoginState.initial(loading: false));
            } else {
              AppSnackBar.error(
                'an error ocurred. please check your internt connection ',
              );
              // emit(LoginState.initial(loading: false));
            }
          },
        );
      } else {
        AppSnackBar.error(' please check your internt connection');
      }
    }
  }
}
