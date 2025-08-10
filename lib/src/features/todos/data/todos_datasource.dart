import 'package:todo_youtube/src/common/database/app_database.dart';
import 'package:todo_youtube/src/common/database/database_helpers/todos_database_helper.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

abstract interface class ITodosDatasource {
  //
  Future<List<Todo>> todos();
}

final class TodosDatasourceRemoteImpl implements ITodosDatasource {
  @override
  Future<List<Todo>> todos() {
    // TODO: implement todos
    throw UnimplementedError();
  }
}

final class TodosDatasourceLocalImpl implements ITodosDatasource {
  TodosDatasourceLocalImpl({required TodosDatabaseHelper todosDatabaseHelper})
    : _todosDatabaseHelper = todosDatabaseHelper;

  final TodosDatabaseHelper _todosDatabaseHelper;

  @override
  Future<List<Todo>> todos() => _todosDatabaseHelper.todos();
}
