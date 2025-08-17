import 'package:todo_youtube/src/common/internet_connection_checker.dart';
import 'package:todo_youtube/src/features/todos/data/todos_datasource.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

abstract interface class ITodosRepository {
  //
  Future<List<Todo>> todos(int userId);

  Future<bool> createTodo(final Todo todo);

  Future<bool> deleteTodo(final String id);

  Future<bool> updateTodo(final Todo todo);
}

final class TodosRepositoryImpl implements ITodosRepository {
  TodosRepositoryImpl({
    required ITodosDatasource todoRemoteDatasource,
    required ITodosDatasource todoLocalDatasource,
    required InternetConnectionChecker internetConnectionChecker,
  }) : _todoRemoteDatasource = todoRemoteDatasource,
       _todoLocalDatasource = todoLocalDatasource,
       _internetConnectionChecker = internetConnectionChecker;

  final ITodosDatasource _todoRemoteDatasource;
  final ITodosDatasource _todoLocalDatasource;
  final InternetConnectionChecker _internetConnectionChecker;

  @override
  Future<List<Todo>> todos(int userId) async {
    // if (await _internetConnectionChecker.hasAccessToInternet()) {
    //   return _todoRemoteDatasource.todos();
    // } else {
    return _todoLocalDatasource.todos(userId);
    // }
  }

  @override
  Future<bool> createTodo(Todo todo) {
    // if (await _internetConnectionChecker.hasAccessToInternet()) {
    //   return _todoRemoteDatasource.createTodo();
    // } else {
    return _todoLocalDatasource.createTodo(todo);
    // }
  }

  @override
  Future<bool> deleteTodo(String id) {
    // if (await _internetConnectionChecker.hasAccessToInternet()) {
    //   return _todoRemoteDatasource.deleteTodo();
    // } else {
    return _todoLocalDatasource.deleteTodo(id);
    // }
  }

  @override
  Future<bool> updateTodo(Todo todo) {
    // if (await _internetConnectionChecker.hasAccessToInternet()) {
    //   return _todoRemoteDatasource.updateTodo();
    // } else {
    return _todoLocalDatasource.updateTodo(todo);
    // }
  }
}
