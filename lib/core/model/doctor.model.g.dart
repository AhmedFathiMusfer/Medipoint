// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  userId: json['userId'] as String,
  fullName: json['fullName'] as String,
  role: json['role'] as String,
  email: json['email'] as String,
  image: json['image'] as String?,
  gender: json['gender'] as String,
  dob: json['dob'] as String?,
  fees: json['fees'] as String,
  experience: json['experience'] as String,
  education: json['education'] as String,
  specialty: json['specialty'] as String,
  about: json['about'] as String?,
  addressLine1: json['addressLine1'] as String?,
  addressLine2: json['addressLine2'] as String?,
  status: const DoctorModelStatusConverter().fromJson(json['status'] as String),
  isVerified: json['isVerified'] as bool,
  degreeDocument: json['degreeDocument'] as String?,
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'role': instance.role,
      'email': instance.email,
      'image': instance.image,
      'gender': instance.gender,
      'dob': instance.dob,
      'fees': instance.fees,
      'experience': instance.experience,
      'education': instance.education,
      'specialty': instance.specialty,
      'about': instance.about,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'status': const DoctorModelStatusConverter().toJson(instance.status),
      'isVerified': instance.isVerified,
      'degreeDocument': instance.degreeDocument,
    };
