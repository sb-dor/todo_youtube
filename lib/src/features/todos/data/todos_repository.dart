import 'package:todo_youtube/src/common/internet_connection_checker.dart';
import 'package:todo_youtube/src/features/todos/data/todos_datasource.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

abstract interface class ITodosRepository {
  //
  Future<List<Todo>> todos();
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
  Future<List<Todo>> todos() async {
    if (await _internetConnectionChecker.hasAccessToInternet()) {
      return _todoRemoteDatasource.todos();
    } else {
      return _todoLocalDatasource.todos();
    }
  }
}
