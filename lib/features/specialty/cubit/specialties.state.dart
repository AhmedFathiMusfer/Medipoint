import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'specialties.state.freezed.dart';

@freezed
class SpecialtiesState with _$SpecialtiesState {
  const factory SpecialtiesState.initial() = _Initial;
  const factory SpecialtiesState.loading() = _Loading;
  const factory SpecialtiesState.success({
    required List<Specialty> specialities,
  }) = _Success;
  const factory SpecialtiesState.error(String message) = _Error;
}
