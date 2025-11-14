import 'package:diagno_bot/core/database/tables/users_tables.dart';
import 'package:drift/drift.dart';
// إذا كان في ملف آخر

class Patients extends Table {
  TextColumn get userId => text().references(Users, #id)();

  @override
  Set<Column> get primaryKey => {userId};
}
