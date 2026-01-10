import 'package:freezed_annotation/freezed_annotation.dart';

part 'resetPassword.state.freezed.dart';

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState.initial({@Default(false) bool loading}) =
      _Initial;
  const factory ResetPasswordState.success() = _Success;
  const factory ResetPasswordState.error(String message) = _Error;
}
