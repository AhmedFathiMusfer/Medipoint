import 'package:diagno_bot/core/database/tables/users_tables.dart';
import 'package:drift/drift.dart';

enum DoctorStatus { A, U }

class DoctorStatusConverter extends TypeConverter<DoctorStatus, String> {
  const DoctorStatusConverter();

  @override
  DoctorStatus fromSql(String fromDb) {
    switch (fromDb) {
      case 'A':
        return DoctorStatus.A;
      case 'U':
        return DoctorStatus.U;
      default:
        throw ArgumentError('Unknown DoctorStatus: $fromDb');
    }
  }

  @override
  String toSql(DoctorStatus value) => value.name;

  String toJson(DoctorStatus value) => value.name;
}

class Doctors extends Table {
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get fees => text()();
  TextColumn get experience => text().withLength(min: 1, max: 30)();
  TextColumn get education => text().withLength(min: 1, max: 100)();
  TextColumn get specialty => text()();
  TextColumn get about => text().nullable()();
  TextColumn get addressLine1 => text().nullable().withLength(max: 255)();
  TextColumn get addressLine2 => text().nullable().withLength(max: 255)();
  TextColumn get status => text().map(const DoctorStatusConverter())();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  TextColumn get degreeDocument => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}
