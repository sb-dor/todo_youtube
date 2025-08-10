import 'package:drift/drift.dart';

class TodosTable extends Table {
  TextColumn get id => text()();

  TextColumn get todo => text()();

  BoolColumn get isDone => boolean().named('is_done')();

  DateTimeColumn get createdAt => dateTime()();
}
