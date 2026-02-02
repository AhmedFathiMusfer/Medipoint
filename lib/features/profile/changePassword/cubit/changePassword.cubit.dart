import 'dart:developer';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/profile/changePassword/cubit/changePassword.state.dart';
import 'package:diagno_bot/features/profile/changePassword/form/changePassword.form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(const ChangePasswordState.initial());

  ChangePasswordForm form = ChangePasswordForm();

  Future<void> changePassword() async {
    if (form.key.currentState!.validate()) {
      emit(const ChangePasswordState.initial(loading: true));
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await RemoteProvider().send(
          request: Request(
            url: ApiConstants.changePasswordEndpoint,
            body: form.body,
          ),
          method: RemoteMethod.put,
          onSuccess: (res, statsCode) {
            log(res.toString());
            AppSnackBar.success('success_password_changed'.tr());
            form.clear();
            emit(const ChangePasswordState.success());
          },
          onError: (error, statsCode) {
            log(error.toString());
            if (statsCode == 400) {
              AppSnackBar.error('error_invalid_old_password'.tr());
              emit(const ChangePasswordState.initial(loading: false));
            } else if (statsCode == 401) {
              AppSnackBar.error('error_unauthorized'.tr());
              emit(const ChangePasswordState.initial(loading: false));
            } else {
              AppSnackBar.error(
                ErrorMessages.instance.fromExceptionType(
                  ExceptionTypes.unexpected,
                ),
              );
              emit(const ChangePasswordState.initial(loading: false));
            }
          },
        );
      } else {
        emit(const ChangePasswordState.initial(loading: false));
        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
      }
    }
  }
}
