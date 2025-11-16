import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'doctors.state.freezed.dart';

@freezed
class DoctorsState with _$DoctorsState {
  const factory DoctorsState.initial() = _Initial;
  const factory DoctorsState.loading() = _Loading;
  const factory DoctorsState.success({
    required List<DoctorModel> doctors,
    @Default('All') String specialtySelected,
    required List<Specialty> specialities,
  }) = _Success;
  const factory DoctorsState.error(String message) = _Error;
}
