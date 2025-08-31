import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_youtube/src/common/database/database_helpers/todos_database_helper.dart';
import 'package:todo_youtube/src/features/todos/data/todos_datasource.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

import '../../../../fakes/fake_todo.dart';
import '../../../../fakes/fake_user.dart';
import 'todos_datasource_test.mocks.dart';

@GenerateMocks([TodosDatabaseHelper])
void main() {
  late TodosDatabaseHelper todosDatabaseHelper;
  late ITodosDatasource todosDatasource;

  setUp(() {
    todosDatabaseHelper = MockTodosDatabaseHelper();
    todosDatasource = TodosDatasourceLocalImpl(todosDatabaseHelper: todosDatabaseHelper);
  });

  group('Todos Datasource', () {
    //
    group('todos method', () {
      //
      test('method should return list of todos', () async {
        //
        when(todosDatabaseHelper.todos(fakeUser.id)).thenAnswer((_) async => [fakeTodo]);

        final todos = await todosDatasource.todos(fakeUser.id);

        expect(todos, isNotEmpty);
        verify(todosDatabaseHelper.todos(fakeUser.id)).called(1);
      });

      //
      test('method should return empty list', () async {
        //
        when(todosDatabaseHelper.todos(fakeUser.id)).thenAnswer((_) async => <Todo>[]);

        final todos = await todosDatasource.todos(fakeUser.id);

        expect(todos, isEmpty);
        verify(todosDatabaseHelper.todos(fakeUser.id)).called(1);
      });

      //
      test('method should throw an exception due to local error', () async {
        //
        when(todosDatabaseHelper.todos(fakeUser.id)).thenThrow(Exception());

        expect(() => todosDatasource.todos(fakeUser.id), throwsA(isA<Exception>()));
      });
    });

    //
    group('createTodo method', () {
      //
      test('method should successfully create todo', () async {
        //
        when(todosDatabaseHelper.createTodo(fakeTodo)).thenAnswer((_) async => true);

        final createTodo = await todosDatasource.createTodo(fakeTodo);

        expect(createTodo, isTrue);
        verify(todosDatabaseHelper.createTodo(fakeTodo)).called(1);
      });

      //
      test('method should throw an exception due to a local error', () async {
        //
        when(todosDatabaseHelper.createTodo(fakeTodo)).thenThrow(Exception());

        expect(() => todosDatasource.createTodo(fakeTodo), throwsA(isA<Exception>()));
      });
    });

    //
    group('deleteTodo method', () {
      //
      test('method should successfully delete todo', () async {
        //
        when(todosDatabaseHelper.deleteTodo(fakeTodo.id)).thenAnswer((_) async => true);

        final deleteTodo = await todosDatasource.deleteTodo(fakeTodo.id);

        expect(deleteTodo, isTrue);
        verify(todosDatabaseHelper.deleteTodo(fakeTodo.id)).called(1);
      });

      //
      test('method should throw an exception due to a local error', () async {
        //
        when(todosDatabaseHelper.deleteTodo(fakeTodo.id)).thenThrow(Exception());

        expect(() => todosDatasource.deleteTodo(fakeTodo.id), throwsA(isA<Exception>()));
      });
    });

    //
    group('updateTodo method', () {
      //
      test('method should successfully update todo', () async {
        //
        when(todosDatabaseHelper.updateTodo(fakeTodo)).thenAnswer((_) async => true);

        final updateTodo = await todosDatasource.updateTodo(fakeTodo);

        expect(updateTodo, isTrue);
        verify(todosDatabaseHelper.updateTodo(fakeTodo)).called(1);
      });

      //
      test('method should throw an exception due to a local error', () async {
        //
        when(todosDatabaseHelper.updateTodo(fakeTodo)).thenThrow(Exception());

        expect(() => todosDatasource.updateTodo(fakeTodo), throwsA(isA<Exception>()));
      });
    });
  });
}
