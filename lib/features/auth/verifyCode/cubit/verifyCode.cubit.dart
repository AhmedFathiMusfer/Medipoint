import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/auth/verifyCode/cubit/verifyCode.state.dart';
import 'package:diagno_bot/features/auth/verifyCode/form/verifyCode.form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  VerifyCodeCubit({required this.email, required this.isResetPassword})
    : super(const VerifyCodeState.initial());

  final String email;
  final bool isResetPassword;
  VerifyCodeForm form = VerifyCodeForm();

  Future<void> submit() async {
    if (form.key.currentState!.validate()) {
      emit(const VerifyCodeState.initial(loading: true));
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await RemoteProvider().send(
          request: Request(
            url:
                isResetPassword
                    ? ApiConstants.verifyCodeEndpoint
                    : ApiConstants.verifyCodeEmailEndpoint,
            body: {...form.body, 'email': email},
          ),
          method: RemoteMethod.post,
          onSuccess: (res, statsCode) {
            String token = res.data['token'] ?? res.data['reset_token'] ?? '';
            AppSnackBar.success('Code verified successfully.');
            emit(VerifyCodeState.success(token: token, email: email));
          },
          onError: (_, statsCode) {
            if (statsCode == 400) {
              AppSnackBar.error('Invalid code. Please try again.');
              emit(const VerifyCodeState.initial(loading: false));
            } else if (statsCode == 404) {
              AppSnackBar.error('Code not found or expired.');
              emit(const VerifyCodeState.initial(loading: false));
            } else {
              AppSnackBar.error('An error occurred. Please try again later.');
              emit(const VerifyCodeState.initial(loading: false));
            }
          },
        );
      } else {
        emit(const VerifyCodeState.initial(loading: false));
        AppSnackBar.error('Please check your internet connection.');
      }
    }
  }
}
