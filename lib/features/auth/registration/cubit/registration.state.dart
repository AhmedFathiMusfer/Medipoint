import 'package:freezed_annotation/freezed_annotation.dart';
part 'registration.state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.initial({@Default(false) bool loading}) =
      _Initial;
  const factory RegisterState.registerSuccess() = _RegisterSuccess;
}
