import 'package:diagno_bot/core/model/base.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'doctorDetails.state.freezed.dart';

@freezed
class DoctorDetailsState with _$DoctorDetailsState {
  const factory DoctorDetailsState.initial() = _Initial;
  const factory DoctorDetailsState.loading() = _Loading;
  const factory DoctorDetailsState.success({required Doctor doctor}) = _Success;
  const factory DoctorDetailsState.error(String message) = _Error;
}
