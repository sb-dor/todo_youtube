import 'package:logger/logger.dart';
import 'package:todo_youtube/src/common/database/app_database.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

class TodosDatabaseHelper {
  TodosDatabaseHelper({required AppDatabase appDatabase, required Logger logger})
    : _appDatabase = appDatabase,
      _logger = logger;

  final AppDatabase _appDatabase;
  final Logger _logger;

  Future<List<Todo>> todos() async {
    final databaseTodos = await _appDatabase.select(_appDatabase.todosTable).get();

    return databaseTodos
        .map(
          (tableData) => Todo(
            tempId: tableData.id,
            todo: tableData.todo,
            isDone: tableData.isDone,
            createdAt: tableData.createdAt,
          ),
        )
        .toList();
  }

  Future<bool> addTodo(Todo todo) async {
    await _appDatabase
        .into(_appDatabase.todosTable)
        .insert(
          TodosTableData(
            id: todo.id,
            todo: todo.todo,
            isDone: todo.isDone,
            createdAt: todo.createdAt,
          ),
        );

    return true;
  }

  Future<bool> deleteTodo(String id) async {
    await (_appDatabase.delete(_appDatabase.todosTable)..where((el) => el.id.equals(id))).go();

    return true;
  }
}
