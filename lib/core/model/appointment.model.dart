import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'appointment.model.g.dart';

@JsonSerializable()
class AppointmentModel {
  final int id;
  @JsonKey(name: 'datetime')
  final String dateTime;
  final AppointmentStatus status;
  final DoctorModel doctor;

  AppointmentModel({
    required this.id,
    required this.dateTime,
    required this.status,
    required this.doctor,
  });
  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}

class AppointmentModelStatusConverter
    implements JsonConverter<AppointmentStatus, String> {
  const AppointmentModelStatusConverter();

  @override
  AppointmentStatus fromJson(String fromDb) {
    switch (fromDb) {
      case 'PE':
        return AppointmentStatus.PE; // Pending
      case 'PA':
        return AppointmentStatus.PA; // Paid
      case 'D':
        return AppointmentStatus.D; // Done
      case 'P':
        return AppointmentStatus.P; // Pending
      case 'M':
        return AppointmentStatus.M; // Missed
      case 'C':
        return AppointmentStatus.C; // Canceled
      case 'DE':
        return AppointmentStatus.DE; // Deleted / Declined
      default:
        throw ArgumentError('Unknown AppointmentStatus value: $fromDb');
    }
  }

  @override
  String toJson(AppointmentStatus value) => value.name;
}
