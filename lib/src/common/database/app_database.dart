import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:todo_youtube/src/common/database/tables/todo_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TodosTable])
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
  int get schemaVersion => 1;
}
