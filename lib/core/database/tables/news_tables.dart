import 'package:drift/drift.dart';

class News extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get image => text()();
  DateTimeColumn? get date => dateTime()();
}
