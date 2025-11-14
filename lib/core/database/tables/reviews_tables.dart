import 'package:diagno_bot/core/database/tables/doctor_tables.dart';
import 'package:diagno_bot/core/database/tables/patients_tables.dart';
import 'package:drift/drift.dart';

class Reviews extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get patientId => text().references(Patients, #userId)();
  IntColumn get rating => integer()();
  TextColumn get content => text().nullable()();
  TextColumn get doctorId => text().nullable().references(Doctors, #userId)();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get updatedAt => text().named('updated_at')();
}
