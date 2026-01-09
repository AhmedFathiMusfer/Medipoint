import 'package:freezed_annotation/freezed_annotation.dart';
part 'changePassword.state.freezed.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState.initial({
    @Default(false) bool loading,
  }) = _Initial;
  const factory ChangePasswordState.success() = _Success;
  const factory ChangePasswordState.error(String message) = _Error;
}