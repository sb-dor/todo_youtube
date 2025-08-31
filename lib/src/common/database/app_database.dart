import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:todo_youtube/src/common/database/tables/todo_table.dart';
import 'package:todo_youtube/src/common/database/tables/user_table.dart';

import 'app_database.steps.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TodosTable, UserTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.custom()
    : super(
        driftDatabase(
          name: "todos_database",
          native: DriftNativeOptions(),
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.dart.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migration) async => await migration.createAll(),
      onUpgrade: stepByStep(
        from1To2: (migration, schema) async {
          await migration.createTable(schema.userTable);
        },
        from2To3: (migration, Schema3 schema) async {
          await migration.addColumn(
            schema.todosTable,
            schema.todosTable.userId,
          );
        },
      ),
    );
  }
}
