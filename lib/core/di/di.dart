// lib/core/di/injector.dart
import 'package:diagno_bot/core/database/daos/users_dao.dart';
import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance; // sl = service locator

Future<void> init() async {
  // قاعدة البيانات
  final db = AppDatabase();
  sl.registerSingleton<AppDatabase>(db);

  // DAO
  sl.registerLazySingleton<UsersDao>(() => UsersDao(sl()));
}
