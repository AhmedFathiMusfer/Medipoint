import 'package:diagno_bot/core/database/tables/users_tables.dart';
import 'package:drift/drift.dart';
import '../drift_db.dart';
import 'base_dao.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase>
    with _$UsersDaoMixin, BaseDaoMixin<Users, User> {
  final AppDatabase db;
  UsersDao(this.db) : super(db);

  @override
  TableInfo<Users, User> get table => users;

  Future<User?> findByEmail(String email) =>
      (select(users)..where((u) => u.email.equals(email))).getSingleOrNull();
}
