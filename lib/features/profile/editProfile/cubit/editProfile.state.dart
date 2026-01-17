import 'package:freezed_annotation/freezed_annotation.dart';
part 'editProfile.state.freezed.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const factory EditProfileState.initial() = _Initial;
  const factory EditProfileState.loading({@Default(false) bool loading}) =
      _Loading;
  const factory EditProfileState.changeProfileImage({
    @Default(null) String? imagePath,
  }) = _ChangeProfileImage;
  const factory EditProfileState.success() = _Success;
  const factory EditProfileState.error(String message) = _Error;
}
