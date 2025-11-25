import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'editProfile.state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState.initial() = _Initial;
  const factory EditProfileState.loading() = _Loading;
  const factory EditProfileState.success({required User user}) = _Success;
  const factory EditProfileState.error(String message) = _Error;
}
