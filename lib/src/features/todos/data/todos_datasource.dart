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
  @override
  Future<List<Todo>> todos() {
    return Future.value(<Todo>[]);
  }
}
