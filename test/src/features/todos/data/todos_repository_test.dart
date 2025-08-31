import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_youtube/src/common/internet_connection_checker.dart';
import 'package:todo_youtube/src/features/todos/data/todos_datasource.dart';
import 'package:todo_youtube/src/features/todos/data/todos_repository.dart';

import '../../../../fakes/fake_todo.dart';
import '../../../../fakes/fake_user.dart';
import 'todos_repository_test.mocks.dart';

@GenerateMocks([ITodosDatasource, InternetConnectionChecker])
void main() {
  late MockITodosDatasource todoRemoteDatasource;
  late MockITodosDatasource todoLocalDatasource;
  late MockInternetConnectionChecker internetConnectionChecker;

  late ITodosRepository todosRepository;

  setUp(() {
    todoRemoteDatasource = MockITodosDatasource();
    todoLocalDatasource = MockITodosDatasource();
    internetConnectionChecker = MockInternetConnectionChecker();

    todosRepository = TodosRepositoryImpl(
      todoRemoteDatasource: todoRemoteDatasource,
      todoLocalDatasource: todoLocalDatasource,
      internetConnectionChecker: internetConnectionChecker,
    );
  });

  group('Todos Repository', () {
    //
    test('todos method should successfully return list of todos', () async {
      //
      when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(todoLocalDatasource.todos(fakeUser.id)).thenAnswer((_) async => [fakeTodo]);

      final todos = await todosRepository.todos(fakeUser.id);

      expect(todos, isNotEmpty);
      verify(todoLocalDatasource.todos(fakeUser.id)).called(1);
    });

    //
    test('createTodo method should successfully create todo', () async {
      //
      when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(todoLocalDatasource.createTodo(fakeTodo)).thenAnswer((_) async => true);

      final createTodo = await todosRepository.createTodo(fakeTodo);

      expect(createTodo, isTrue);
      verify(todoLocalDatasource.createTodo(fakeTodo)).called(1);
    });

    //
    test('deleteTodo method should successfully delete todo', () async {
      //
      when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(todoLocalDatasource.deleteTodo(fakeTodo.id)).thenAnswer((_) async => true);

      final deleteTodo = await todosRepository.deleteTodo(fakeTodo.id);

      expect(deleteTodo, isTrue);
      verify(todoLocalDatasource.deleteTodo(fakeTodo.id)).called(1);
    });

    //
    test('createTodo method should successfully update todo', () async {
      //
      when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(todoLocalDatasource.updateTodo(fakeTodo)).thenAnswer((_) async => true);

      final updateTodo = await todosRepository.updateTodo(fakeTodo);

      expect(updateTodo, isTrue);
      verify(todoLocalDatasource.updateTodo(fakeTodo)).called(1);
    });
  });
}
