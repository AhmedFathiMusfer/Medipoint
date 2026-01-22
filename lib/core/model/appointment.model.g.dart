// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      id: (json['id'] as num).toInt(),
      dateTime: json['datetime'] as String,
      fees: json['fees'] as String?,
      status: json['status'],
      doctor: DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'datetime': instance.dateTime,
      'status': _$AppointmentStatusEnumMap[instance.status]!,
      'fees': instance.fees,
      'doctor': instance.doctor,
    };

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.P: 'P',
  AppointmentStatus.PE: 'PE',
  AppointmentStatus.PA: 'PA',
  AppointmentStatus.D: 'D',
  AppointmentStatus.M: 'M',
  AppointmentStatus.C: 'C',
  AppointmentStatus.DE: 'DE',
};
