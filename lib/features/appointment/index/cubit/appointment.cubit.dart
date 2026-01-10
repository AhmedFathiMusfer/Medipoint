import 'dart:developer';

import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/helpers/networkHelper.dart';
import 'package:diagno_bot/core/model/appointment.model.dart';
import 'package:diagno_bot/core/model/doctor.model.dart';
import 'package:diagno_bot/core/networking/errors/errorMesage.dart';
import 'package:diagno_bot/core/networking/errors/exceptions.enum.dart';
import 'package:diagno_bot/core/networking/remote/apiConstants.dart';
import 'package:diagno_bot/core/networking/remote/remoteProvider.dart';
import 'package:diagno_bot/core/networking/remote/requestOptions.dart';
import 'package:diagno_bot/core/widgets/appSnackBar.dart';
import 'package:diagno_bot/features/appointment/index/cubit/appointment.state.dart';
import 'package:drift/drift.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentState.initial());
  AppDatabase db = AppDatabase();
  Future<void> loadAll() async {
    emit(AppointmentState.loading());
    if (await getAppointmentsLength() == 0) {
      await loadOnlineData();
    } else {
      await loadLocalData();
      await loadOnlineData();
    }
  }

  Future<void> loadLocalData() async {
    try {
      final results = await Future.wait([getAppointments()]);

      final appointments = results[0];
      if (!isClosed) {
        emit(AppointmentState.success(appointments: appointments));
      }
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected) +
            e.toString(),
      );
    }
  }

  Future<void> loadOnlineData() async {
    try {
      bool isConnected = await NetworkHelper.isConnected();
      if (isConnected) {
        await Future.wait([fetchAppointments()]);
      } else {
        AppSnackBar.error(
          ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection),
        );
      }
      await loadLocalData();
    } catch (e) {
      AppSnackBar.error(
        ErrorMessages.instance.fromExceptionType(ExceptionTypes.unexpected) +
            e.toString(),
      );
    }
  }

  // ******************************************Api************************************************************
  Future<void> fetchAppointments() async {
    bool isConnected = await NetworkHelper.isConnected();

    if (isConnected) {
      await RemoteProvider().send(
        request: Request(url: ApiConstants.appointmentsEndpoint),
        method: RemoteMethod.get,
        onSuccess: (res, statsCode) async {
          try {
            if (res.data['results'].isNotEmpty) {
              log(res.data['results'].toString());
              await insertAppointment(res.data['results']);
            }
          } catch (ex) {
            AppSnackBar.error(
              ErrorMessages.instance.fromExceptionType(
                    ExceptionTypes.unexpected,
                  ) +
                  ex.toString(),
            );
          }
        },
        onError: (_, statsCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
        },
      );
    } else {}
  }

  Future<void> cancelAppointment(int appointmentId) async {
    bool isConnected = await NetworkHelper.isConnected();

    if (isConnected) {
      await RemoteProvider().send(
        request: Request(
          url: ApiConstants.cancelAppointmentEndpoint(appointmentId),
        ),
        method: RemoteMethod.post,
        onSuccess: (res, statsCode) async {
          try {
            await loadOnlineData();
          } catch (ex) {
            AppSnackBar.error(
              ErrorMessages.instance.fromExceptionType(
                    ExceptionTypes.unexpected,
                  ) +
                  ex.toString(),
            );
          }
        },
        onError: (_, statsCode) {
          AppSnackBar.error(ErrorMessages.instance.fromStatusCode(statsCode));
        },
      );
    } else {
      ErrorMessages.instance.fromExceptionType(ExceptionTypes.connection);
    }
  }

  // ******************************************db************************************************************
  Future<List<AppointmentModel>> getAppointments() async {
    final result =
        await (db.select(db.appointments).join([
          innerJoin(
            db.doctors,
            db.doctors.userId.equalsExp(db.appointments.doctorId),
          ),
          innerJoin(db.users, db.users.id.equalsExp(db.doctors.userId)),
        ])).get();

    final jsonList =
        result.map((row) {
          final appointment = row.readTable(db.appointments).toJson();
          final doctor = row.readTable(db.doctors).toJson();
          final user = row.readTable(db.users).toJson();
          doctor['status'] = DoctorModelStatusConverter().toJson(
            doctor['status'],
          );

          return {
            ...appointment,
            "doctor": {...doctor, ...user},
          };
        }).toList();

    final appointments =
        jsonList
            .map<AppointmentModel>((data) => AppointmentModel.fromJson(data))
            .toList();
    log(appointments.toString());
    return appointments;
  }

  Future<int> getAppointmentsLength() async {
    return (await (db.select(db.appointments).get())).length;
  }

  insertAppointment(appointments) async {
    await db.batch((batch) async {
      for (var appointment in appointments) {
        batch.insert(
          db.appointments,
          AppointmentsCompanion(
            id: Value(appointment['id']),
            additionalInfo: Value(appointment['additional_info']),
            datetime: Value(appointment['datetime']),
            doctorId: Value(appointment['doctor']['user']['id']),
            patientId: Value(appointment['patient']),
            status: Value(
              const AppointmentStatusConverter().fromJson(
                appointment['status'],
              ),
            ),
            workingHoursId: Value(appointment['working_hours']),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}
