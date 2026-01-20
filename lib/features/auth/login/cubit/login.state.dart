import 'package:freezed_annotation/freezed_annotation.dart';
part 'login.state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loding({@Default(false) bool loading}) = _Loding;

  const factory LoginState.loginSuccess() = _LoginSuccess;
}
