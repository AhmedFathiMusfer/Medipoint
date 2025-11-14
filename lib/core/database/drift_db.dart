import 'dart:io';
import 'package:diagno_bot/core/database/daos/users_dao.dart';
import 'package:diagno_bot/core/database/tables/appointments_tables.dart';
import 'package:diagno_bot/core/database/tables/comments_tables.dart';
import 'package:diagno_bot/core/database/tables/doctor_tables.dart';
import 'package:diagno_bot/core/database/tables/news_tables.dart';
import 'package:diagno_bot/core/database/tables/patients_tables.dart';
import 'package:diagno_bot/core/database/tables/reviews_tables.dart';
import 'package:diagno_bot/core/database/tables/specialties_tables.dart';
import 'package:diagno_bot/core/database/tables/users_tables.dart';
import 'package:diagno_bot/core/database/tables/working_hours_tables.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'drift_db.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Doctors,
    News,
    Specialties,
    Patients,
    WorkingHours,
    Reviews,
    Comments,
    Appointments,
  ],
  daos: [UsersDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());
  // Singleton instance
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        // مثال: await m.addColumn(users, users.phone);
      }
      // خطوات إضافية حسب from -> to
    },
    beforeOpen: (details) async {
      // خيارات قبل الفتح إن احتجت
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_db.sqlite'));
    return NativeDatabase(file);
  });
}
