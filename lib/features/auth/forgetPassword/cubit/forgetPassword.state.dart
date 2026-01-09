import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgetPassword.state.freezed.dart';

@freezed
class ForgetPasswordState with _$ForgetPasswordState {
  const factory ForgetPasswordState.initial({@Default(false) bool loading}) =
      _Initial;
  const factory ForgetPasswordState.success({required String email}) = _Success;
}
