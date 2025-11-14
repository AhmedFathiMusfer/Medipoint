import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookAppointment.state.freezed.dart';

@freezed
class BookAppointmentState with _$BookAppointmentState {
  const factory BookAppointmentState({
    DateTime? selectedDate,
    String? selectedHour,
  }) = _BookAppointmentState;
}
