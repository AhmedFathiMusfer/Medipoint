import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'appointment.model.g.dart';

@JsonSerializable()
class AppointmentModel {
  final int id;
  @JsonKey(name: 'datetime')
  final String dateTime;
  final DoctorModel doctor;

  AppointmentModel({
    required this.id,
    required this.dateTime,
    required this.doctor,
  });
  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}
