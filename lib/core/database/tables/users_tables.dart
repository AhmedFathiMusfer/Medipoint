import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:drift/drift.dart';

import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get role => text()();
  TextColumn get email => text()();
  TextColumn get image => text().nullable()();
  TextColumn get fullName => text().named('full_name')();
  TextColumn get gender => text()();
  TextColumn get dob => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
