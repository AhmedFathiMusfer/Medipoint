import 'package:diagno_bot/core/database/tables/patient_folders_tables.dart';
import 'package:drift/drift.dart';

class PatientFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get file => text().nullable()();
  TextColumn get localPath => text()();
  IntColumn get folderId =>
      integer().named('folder').references(PatientFolders, #id)();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get updatedAt => text().named('updated_at')();
}
