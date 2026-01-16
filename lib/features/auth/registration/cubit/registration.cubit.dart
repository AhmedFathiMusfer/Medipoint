import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/auth/registration/cubit/registration.state.dart';
import 'package:diagno_bot/features/auth/registration/form/register.form.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super((const RegisterState.initial()));
  RegisterForm form = RegisterForm();

  supmit() async {
    // emit(RegisterState.registerSuccess());
    if (form.key.currentState!.validate()) {
      emit(RegisterState.initial(loading: true));
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await RemoteProvider().send(
          request: Request(url: ApiConstants.registerEndpoint, body: form.body),
          method: RemoteMethod.post,
          onSuccess: (res, statsCode) async {
            res.data['password'] = form.body['password'];
            await AuthManager().setUser(res.data);
            emit(RegisterState.registerSuccess());
          },
          onError: (_, statsCode) {
            if (statsCode == 400) {
              AppSnackBar.error('this eamil is already exit');
              emit(RegisterState.initial(loading: false));
            } else {
              AppSnackBar.error(
                'an error ocurred. please check your internt connection ',
              );
              emit(RegisterState.initial(loading: false));
            }
          },
        );
      } else {
        AppSnackBar.error(' please check your internt connection');
      }
    }
  }
}
