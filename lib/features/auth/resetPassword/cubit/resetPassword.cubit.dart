import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/auth/resetPassword/cubit/resetPassword.state.dart';
import 'package:diagno_bot/features/auth/resetPassword/form/resetPassword.form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({required this.token, required this.email})
    : super(const ResetPasswordState.initial());

  final String token;
  final String email;

  ResetPasswordForm form = ResetPasswordForm();

  Future<void> resetPassword() async {
    if (form.key.currentState!.validate()) {
      emit(const ResetPasswordState.initial(loading: true));
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await RemoteProvider().send(
          request: Request(
            url: ApiConstants.resetPasswordEndpoint,
            body: {...form.body, 'token': token, 'email': email},
            header: {'Content-Type': 'application/json'},
          ),
          method: RemoteMethod.post,
          onSuccess: (res, statsCode) {
            AppSnackBar.success('success_password_reset'.tr());
            form.clear();
            emit(const ResetPasswordState.success());
          },
          onError: (_, statsCode) {
            if (statsCode == 400) {
              AppSnackBar.error(
                'error_invalid_token_password'.tr(),
              );
              emit(const ResetPasswordState.initial(loading: false));
            } else if (statsCode == 404) {
              AppSnackBar.error('error_token_not_found'.tr());
              emit(const ResetPasswordState.initial(loading: false));
            } else {
              AppSnackBar.error('error_occurred_try_later'.tr());
              emit(const ResetPasswordState.initial(loading: false));
            }
          },
        );
      } else {
        emit(const ResetPasswordState.initial(loading: false));
        AppSnackBar.error('error_check_internet_connection'.tr());
      }
    }
  }
}
