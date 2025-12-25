import 'dart:developer';
import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/auth/login/cubit/login.state.dart';
import 'package:diagno_bot/features/auth/login/form/login.form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  LoginForm form = LoginForm();
  inital() {
    var user = AuthManager().currentUser;
    log(user.toString());
    if (user != null) {
      form.emailController.text = user.email;
      form.passwordController.text = user.password ?? "";
    }
  }

  supmit() async {
    if (form.key.currentState!.validate()) {
      emit(LoginState.initial(loading: true));
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await RemoteProvider().send(
          request: Request(url: ApiConstants.loginEndpoint, body: form.body),
          method: RemoteMethod.post,
          onSuccess: (res, statsCode) async {
            log(res.toString());
            await AuthManager().setToken(res.data);
            emit(LoginState.loginSuccess());
          },
          onError: (_, statsCode) {
            if (statsCode == 400) {
              AppSnackBar.error('the data entry is inValid');
              emit(LoginState.initial(loading: false));
            } else if (statsCode == 401) {
              AppSnackBar.error('Incorrect email or password.');
              emit(LoginState.initial(loading: false));
            } else {
              AppSnackBar.error(
                ErrorMessages.instance.fromExceptionType(
                  ExceptionTypes.unexpected,
                ),
              );
              emit(LoginState.initial(loading: false));
            }
          },
        );
      } else {
        emit(LoginState.initial(loading: false));

        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
      }
    }
  }
}
