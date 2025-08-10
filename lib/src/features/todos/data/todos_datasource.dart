import 'package:todo_youtube/src/common/database/database_helpers/todos_database_helper.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

abstract interface class ITodosDatasource {
  //
  Future<List<Todo>> todos();

  Future<bool> createTodo(final Todo todo);

  Future<bool> deleteTodo(final String id);

  Future<bool> updateTodo(final Todo todo);
}

final class TodosDatasourceRemoteImpl implements ITodosDatasource {
  @override
  Future<List<Todo>> todos() => Future.value(<Todo>[]);

  @override
  Future<bool> createTodo(Todo todo) => Future.value(false);

  @override
  Future<bool> deleteTodo(String id) => Future.value(false);

  @override
  Future<bool> updateTodo(Todo todo) => Future.value(false);
}

final class TodosDatasourceLocalImpl implements ITodosDatasource {
  TodosDatasourceLocalImpl({required TodosDatabaseHelper todosDatabaseHelper})
    : _todosDatabaseHelper = todosDatabaseHelper;

  final TodosDatabaseHelper _todosDatabaseHelper;

  @override
  Future<List<Todo>> todos() => _todosDatabaseHelper.todos();

  @override
  Future<bool> createTodo(final Todo todo) => _todosDatabaseHelper.createTodo(todo);

  @override
  Future<bool> deleteTodo(final String id) => _todosDatabaseHelper.deleteTodo(id);

  @override
  Future<bool> updateTodo(Todo todo) => _todosDatabaseHelper.updateTodo(todo);
}
