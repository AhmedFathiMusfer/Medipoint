import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/doctor_tables.dart';
import 'package:json_annotation/json_annotation.dart';
part 'doctor.model.g.dart';

@JsonSerializable(explicitToJson: true)
class DoctorModel {
  final String userId;
  final String fullName;
  final String role;
  final String email;
  final String? image;
  final String gender;
  final String? dob;

  final String fees;
  final String experience;
  final String education;
  final String specialty;
  final String? specialtyAr;

  final String? about;
  final int? reviews;
  final double? rating;

  final String? addressLine1;
  final String? addressLine2;
  @DoctorModelStatusConverter()
  final DoctorStatus status;
  final bool isVerified;
  final String? degreeDocument;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Review? review;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<WorkingHour> workingHours;

  DoctorModel({
    required this.userId,
    required this.fullName,
    required this.role,
    required this.email,
    this.image,
    required this.gender,
    this.dob,
    required this.fees,
    required this.experience,
    required this.education,
    required this.specialty,
    required this.specialtyAr,

    this.about,
    this.rating,
    this.reviews,
    this.review,
    this.addressLine1,
    this.addressLine2,
    required this.status,
    required this.isVerified,
    this.degreeDocument,
    this.workingHours = const [],
  });
  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}

class DoctorModelStatusConverter
    implements JsonConverter<DoctorStatus, String> {
  const DoctorModelStatusConverter();

  @override
  DoctorStatus fromJson(String json) {
    switch (json) {
      case 'A':
        return DoctorStatus.A;
      case 'U':
        return DoctorStatus.U;
      default:
        throw ArgumentError('Unknown DoctorStatus: $json');
    }
  }

  @override
  String toJson(DoctorStatus object) => object.name;
}
