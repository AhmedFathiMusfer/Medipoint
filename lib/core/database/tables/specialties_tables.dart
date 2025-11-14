import 'package:drift/drift.dart';

class Specialties extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get slug => text().customConstraint('UNIQUE NOT NULL')();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get icon => text().nullable()();
}
