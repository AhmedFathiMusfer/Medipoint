import 'package:diagno_bot/core/database/tables/doctor_tables.dart';
import 'package:diagno_bot/core/database/tables/patients_tables.dart';
import 'package:diagno_bot/core/database/tables/working_hours_tables.dart';
import 'package:drift/drift.dart';

enum AppointmentStatus { PE, PA, D, M, C, DE }

class AppointmentStatusConverter
    extends TypeConverter<AppointmentStatus, String> {
  const AppointmentStatusConverter();

  @override
  AppointmentStatus fromSql(String fromDb) {
    switch (fromDb) {
      case 'PE':
        return AppointmentStatus.PE; // Pending
      case 'PA':
        return AppointmentStatus.PA; // Paid
      case 'D':
        return AppointmentStatus.D; // Done
      case 'M':
        return AppointmentStatus.M; // Missed
      case 'C':
        return AppointmentStatus.C; // Canceled
      case 'DE':
        return AppointmentStatus.DE; // Deleted / Declined
      default:
        throw ArgumentError('Unknown AppointmentStatus value: $fromDb');
    }
  }

  @override
  String toSql(AppointmentStatus value) => value.name;
}

class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get patientId => text().references(Patients, #userId)();
  TextColumn get doctorId => text().references(Doctors, #userId)();
  TextColumn get datetime => text()();
  TextColumn get status => text().map(const AppointmentStatusConverter())();
  TextColumn get fees => text().nullable()();
  IntColumn get workingHoursId => integer().references(WorkingHours, #id)();
  TextColumn get additionalInfo => text().nullable().named('additional_info')();
}
