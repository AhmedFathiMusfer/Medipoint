import 'package:diagno_bot/core/database/tables/doctor_tables.dart';
import 'package:drift/drift.dart';

class WorkingHours extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get startTime => text()();
  TextColumn get endTime => text()();
  TextColumn get doctorId => text().references(Doctors, #userId)();
  IntColumn get patientLeft => integer().nullable()();
}
