import 'package:diagno_bot/core/database/tables/reviews_tables.dart';
import 'package:diagno_bot/core/database/tables/users_tables.dart';
import 'package:drift/drift.dart';

enum CommentType { D, P }

class CommentTypeConverter extends TypeConverter<CommentType, String> {
  const CommentTypeConverter();

  @override
  CommentType fromSql(String fromDb) {
    switch (fromDb) {
      case 'D':
        return CommentType.D;
      case 'P':
        return CommentType.P;
      default:
        throw ArgumentError('Unknown CommentType: $fromDb');
    }
  }

  @override
  String toSql(CommentType value) => value.name;
}

class Comments extends Table {
  IntColumn get id => integer()();
  IntColumn get reviewId => integer().references(Reviews, #id)();
  TextColumn get type => text().map(const CommentTypeConverter())();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get content => text().withLength(min: 1)();
  TextColumn get createdAt => text().named('created_at')();
  TextColumn get updatedAt => text().named('updated_at')();
}
