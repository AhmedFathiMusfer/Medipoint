import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/database/tables/doctor_tables.dart';
import 'package:diagno_bot/core/database/tables/patient_folders_tables.dart';
import 'package:diagno_bot/core/database/tables/patients_tables.dart';
import 'package:drift/drift.dart';

/// نوع المشاركة: إما مباشر للدكتور أو عبر حجز
enum SharingType { DOCTOR, APPOINTMENT }

class SharingTypeConverter extends TypeConverter<SharingType, String> {
  const SharingTypeConverter();

  @override
  SharingType fromSql(String fromDb) {
    switch (fromDb) {
      case 'DOCTOR':
        return SharingType.DOCTOR;
      case 'APPOINTMENT':
        return SharingType.APPOINTMENT;
      default:
        throw ArgumentError('Unknown SharingType value: $fromDb');
    }
  }

  @override
  String toSql(SharingType value) => value.name;

  SharingType fromJson(String fromDb) {
    switch (fromDb) {
      case 'DOCTOR':
        return SharingType.DOCTOR;
      case 'APPOINTMENT':
        return SharingType.APPOINTMENT;
      default:
        throw ArgumentError('Unknown SharingType value: $fromDb');
    }
  }
}

class PatientSharedFolders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get patientId => text().references(Patients, #userId)();
  TextColumn get doctorId => text().references(Doctors, #userId)();
  IntColumn get folderId => integer().references(PatientFolders, #id)();
  IntColumn get appointmentId =>
      integer().nullable().references(Appointments, #id)();
  TextColumn get sharingType => text().map(const SharingTypeConverter())();
  TextColumn get createdAt => text().named('created_at')();
}
