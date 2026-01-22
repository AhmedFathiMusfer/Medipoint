import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/appointment/bookAppointment/cubit/bookAppointment.state.dart';
import 'package:diagno_bot/core/notifaction/notifaction.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final List<WorkingHour> workingHours;
  final String doctorId;
  BookAppointmentCubit({required this.workingHours, required this.doctorId})
    : super(const BookAppointmentState.initial());
  AppDatabase db = AppDatabase();
  loading() {
    emit(const BookAppointmentState.loading());
    final allowedWeekdays = getAllowedWeekdays(workingHours);
    final availableTimes =
        workingHours.isNotEmpty
            ? getPeriodsByDay(
              workingHours,
              DateTime.parse(workingHours[0].startTime),
            )
            : List<WorkingHour>.empty(growable: true);
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
    var time = getPeriodsByDay(workingHours, date);
    state.mapOrNull(
      success: (state) {
        if (!isClosed) {
          emit(
            state.copyWith(
              selectedDate: date,
              availableTimes: time,
              selectedHour: null,
            ),
          );
        }
      },
    );
  }

  void selectPeriod(WorkingHour period) {
    state.mapOrNull(
      success: (state) {
        emit(state.copyWith(selectedHour: period));
      },
    );
  }

  Future<void> addBooking(int workingHourId) async {
    state.mapOrNull(
      success: (state) {
        emit(state.copyWith(isBookingInProgress: true));
      },
    );
    var result = await booKing(workingHourId);
    if (result != null) {
      state.mapOrNull(
        success: (state) {
          emit(state.copyWith(isSuccessBooking: true, appointmentId: result));
        },
      );
    }
    state.mapOrNull(
      success: (state) {
        emit(state.copyWith(isBookingInProgress: false));
      },
    );
  }

  List<DateTime> getAllowedWeekdays(List<WorkingHour> workingHours) {
    final Set<DateTime> days = {};

    for (var wh in workingHours) {
      final start = DateTime.parse(wh.startTime);
      days.add(start);
    }

    return days.toList()..sort();
  }

  List<WorkingHour> getPeriodsByDay(
    List<WorkingHour> workingHours,
    DateTime selectedDay,
  ) {
    final List<WorkingHour> periods = [];
    for (var wh in workingHours) {
      final start = DateTime.parse(wh.startTime);
      if (start.year == selectedDay.year &&
          start.month == selectedDay.month &&
          start.day == selectedDay.day) {
        periods.add(wh);
      }
    }

    return periods;
  }

  // ******************************************Api************************************************************
  booKing(int workingHourId) async {
    bool isConnected = await NetworkHelper.isConnected();
    if (!isConnected) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
      );
      return false;
    }
    var rsponse = await RemoteProvider().send(
      request: Request(
        url: ApiConstants.appointmentsEndpoint,
        body: {
          "status": "PE",
          "working_hours": workingHourId,
          "additional_info": "string",
        },
      ),
      method: RemoteMethod.post,
      onSuccess: (res, statsCode) async {
        try {
          if (res.data != null) {
            await insertAppointment(res.data);
            await NotificationService.scheduleAppointmentNotification(
              id: res.data['id'],
              appointmentTime: DateTime.parse(res.data['datetime']),
              minutesBefore: 10,
            );
          }
        } catch (ex) {
          AppSnackBar.error(
            ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected),
          );
        }
      },
      onError: (_, statsCode) {
        AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
      },
    );
    if (rsponse.statusCode == 201) {
      return rsponse.data['id'];
    } else {
      return null;
    }
  }
  // ******************************************db************************************************************

  insertAppointment(data) async {
    await db.batch((batch) async {
      batch.insert(
        db.appointments,
        AppointmentsCompanion(
          id: Value(data['id']),
          additionalInfo: Value(data['additional_info']),
          datetime: Value(data['datetime']),
          doctorId: Value(data['doctor']['user']['id']),
          patientId: Value(data['patient']),
          status: Value(
            const AppointmentStatusConverter().fromJson(data['status']),
          ),
          workingHoursId: Value(data['working_hours']),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}
