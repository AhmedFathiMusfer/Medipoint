import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/auth/forgetPassword/cubit/forgetPassword.state.dart';
import 'package:diagno_bot/features/auth/forgetPassword/form/forgetPassword.form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(const ForgetPasswordState.initial());

  ForgetPasswordForm form = ForgetPasswordForm();

  Future<void> submit() async {
    if (form.key.currentState!.validate()) {
      emit(const ForgetPasswordState.initial(loading: true));
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await RemoteProvider().send(
          request: Request(
            url: ApiConstants.forgetPasswordEndpoint,
            body: form.body,
          ),
          method: RemoteMethod.post,
          onSuccess: (res, statsCode) {
            AppSnackBar.success(
              'success_password_reset_email_sent'.tr(),
            );
            emit(ForgetPasswordState.success(email: form.emailController.text));
          },
          onError: (_, statsCode) {
            if (statsCode == 400) {
              AppSnackBar.error('error_invalid_email'.tr());
              emit(const ForgetPasswordState.initial(loading: false));
            } else if (statsCode == 404) {
              AppSnackBar.error('error_email_not_found'.tr());
              emit(const ForgetPasswordState.initial(loading: false));
            } else {
              AppSnackBar.error(
                'error_occurred_try_later'.tr(),
              );
              emit(const ForgetPasswordState.initial(loading: false));
            }
          },
        );
      } else {
        emit(const ForgetPasswordState.initial(loading: false));
        AppSnackBar.error('error_check_internet_connection'.tr());
      }
    }
  }
}
