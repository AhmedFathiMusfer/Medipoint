import 'package:freezed_annotation/freezed_annotation.dart';

part 'verifyCode.state.freezed.dart';

@freezed
class VerifyCodeState with _$VerifyCodeState {
  const factory VerifyCodeState.initial({@Default(false) bool loading}) =
      _Initial;
  const factory VerifyCodeState.success({required String token}) = _Success;
}
