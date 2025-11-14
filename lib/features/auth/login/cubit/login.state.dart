import 'package:freezed_annotation/freezed_annotation.dart';
part 'login.state.freezed.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthProfileSaved extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial({@Default(false) bool loading}) = _Initial;
  const factory LoginState.loginSuccess() = _LoginSuccess;
}
