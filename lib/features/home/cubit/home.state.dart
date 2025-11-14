import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/specialties_tables.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'home.state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.success({
    required List<Specialty> specialties,
    required List<DoctorModel> doctors,
    required List<DoctorModel> filteredDoctors,
  }) = _Success;
  const factory HomeState.error(String message) = _Error;
}
