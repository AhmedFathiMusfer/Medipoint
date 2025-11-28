import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/features/bookAppointment/cubit/bookAppointment.state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final List<WorkingHour> workingHours;
  final String doctorId;
  BookAppointmentCubit({required this.workingHours, required this.doctorId})
    : super(const BookAppointmentState.initial());

  loading() {
    emit(const BookAppointmentState.loading());
    final allowedWeekdays = getAllowedWeekdays(workingHours);
    final availableTimes = generateTimes(workingHours);
    emit(
      BookAppointmentState.success(
        allowedWeekdays: allowedWeekdays,
        availableTimes: availableTimes,
        selectedDate:
            workingHours.isNotEmpty
                ? DateTime.parse(workingHours[0].startTime)
                : null,
      ),
    );
  }

  void selectDate(DateTime date) {
    state.mapOrNull(
      success: (state) {
        if (!isClosed) {
          emit(state.copyWith(selectedDate: date));
        }
      },
    );
  }

  void selectHour(String hour) {
    state.mapOrNull(
      success: (state) {
        emit(state.copyWith(selectedHour: hour));
      },
    );
  }

  List<int> getAllowedWeekdays(List<WorkingHour> workingHours) {
    final Set<int> days = {};

    for (var wh in workingHours) {
      final start = DateTime.parse(wh.startTime);
      days.add(start.weekday);
    }

    return days.toList()..sort();
  }

  List<String> generateTimes(List<WorkingHour> workingHours) {
    final List<String> result = [];

    for (var wh in workingHours) {
      final start = DateTime.parse(wh.startTime);
      final end = DateTime.parse(wh.endTime);

      DateTime current = start;

      while (current.isBefore(end)) {
        result.add(DateFormat("hh.mm a").format(current));
        current = current.add(Duration(minutes: 30));
      }
    }

    return result;
  }
}
