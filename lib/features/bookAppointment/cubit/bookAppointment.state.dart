import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookAppointment.state.freezed.dart';

@freezed
class BookAppointmentState with _$BookAppointmentState {
  const factory BookAppointmentState.initial() = _Initial;
  const factory BookAppointmentState.loading() = _Loading;
  const factory BookAppointmentState.success({
    DateTime? selectedDate,
    String? selectedHour,
    required List<int> allowedWeekdays,
    required List<String> availableTimes,
  }) = _Success;
  const factory BookAppointmentState.error(String message) = _Error;
}
