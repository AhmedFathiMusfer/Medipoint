import 'dart:developer';

import 'package:diagno_bot/core/auth/authManager.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/auth/registration/cubit/registration.state.dart';
import 'package:diagno_bot/features/auth/registration/form/register.form.dart';
import 'package:easy_localization/easy_localization.dart';
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
            log(res.data.toString());
            if (res.data['message'] != null &&
                res.data['message'].toString().contains(
                  'Verification OTP resent. Please verify your email',
                )) {
              if (res.data['email'] != null) {
                await AuthManager().setUser(res.data);
              }
              emit(RegisterState.registerSuccess());
              return;
            }
            await AuthManager().setUser(res.data);
            emit(RegisterState.registerSuccess());
          },
          onError: (res, statsCode) {
            if (statsCode == 400) {
              AppSnackBar.error('error_email_already_exists'.tr());
              emit(RegisterState.initial(loading: false));
            } else {
              AppSnackBar.error(
                ErrorMessages.instance.fromExceptionType(
                  ExceptionTypes.unexpected,
                ),
              );
              emit(RegisterState.initial(loading: false));
            }
          },
        );
      } else {
        emit(RegisterState.initial(loading: false));
        AppSnackBar.error('error_check_internet_connection'.tr());
      }
    }
  }
}
