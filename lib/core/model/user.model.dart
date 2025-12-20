import 'package:json_annotation/json_annotation.dart';
part 'user.model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String email;
  final String? password;
  final String? image;
  final String? gender;
  final String role;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.password,
    required this.role,
    this.image,
    this.gender,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
