import 'package:drift/drift.dart';
import '../drift_db.dart';

mixin BaseDaoMixin<T extends Table, D extends DataClass>
    on DatabaseAccessor<AppDatabase> {
  TableInfo<T, D> get table;

  Future<List<D>> getAll() => select(table).get();
  Stream<List<D>> watchAll() => select(table).watch();
  Future<int> insertItem(Insertable<D> item) => into(table).insert(item);
  Future<bool> updateItem(Insertable<D> item) => update(table).replace(item);
  Future<int> deleteItem(Insertable<D> item) => delete(table).delete(item);
}
