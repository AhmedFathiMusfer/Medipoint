import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookAppointment.state.freezed.dart';

@freezed
class BookAppointmentState with _$BookAppointmentState {
  const factory BookAppointmentState.initial() = _Initial;
  const factory BookAppointmentState.loading() = _Loading;
  const factory BookAppointmentState.success({
    DateTime? selectedDate,
    WorkingHour? selectedHour,
    @Default(false) bool isBookingInProgress,
    @Default(false) bool isSuccessBooking,
    int? appointmentId,
    required List<DateTime> allowedWeekdays,
    required List<WorkingHour> availableTimes,
  }) = _Success;
  const factory BookAppointmentState.error(String message) = _Error;
}
