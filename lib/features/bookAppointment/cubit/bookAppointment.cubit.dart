import 'package:diagno_bot/features/bookAppointment/cubit/bookAppointment.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  BookAppointmentCubit() : super(const BookAppointmentState());

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void selectHour(String hour) {
    emit(state.copyWith(selectedHour: hour));
  }
}
