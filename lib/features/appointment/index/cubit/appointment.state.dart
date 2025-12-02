import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/model/appointment.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment.state.freezed.dart';

@freezed
class AppointmentState with _$AppointmentState {
  const factory AppointmentState.initial() = _Initial;
  const factory AppointmentState.loading() = _Loading;
  const factory AppointmentState.success({
    required List<AppointmentModel> appointments,
  }) = _Success;
  const factory AppointmentState.error(String message) = _Error;
}
