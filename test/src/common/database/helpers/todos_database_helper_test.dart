import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:todo_youtube/src/common/database/app_database.dart';
import 'package:todo_youtube/src/common/database/database_helpers/todos_database_helper.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

import '../../../../fakes/fake_todo.dart';

void main() {
  late AppDatabase appDatabase;
  late TodosDatabaseHelper todosDatabaseHelper;

  setUp(() {
    final logger = Logger();
    appDatabase = AppDatabase(
      drift.DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
    );
    todosDatabaseHelper = TodosDatabaseHelper(appDatabase: appDatabase, logger: logger);
  });

  tearDown(() {
    appDatabase.close();
  });

  group('Todos Database Helper', () {
    //
    group("todos and createTodo methods", () {
      //
      test(
        'todos and create methods should successfully create then return created data by correct user_id',
        () async {
          final isTodoCreated = await todosDatabaseHelper.createTodo(fakeTodo);

          expect(isTodoCreated, isTrue);

          final todos = await todosDatabaseHelper.todos(1);

          expect(todos, isNotEmpty);
          expect(todos.first.userId, fakeTodo.userId);
        },
      );

      //
      test(
        'todos and create methods should successfully create then return empty data by incorrect user_id',
        () async {
          final isTodoCreated = await todosDatabaseHelper.createTodo(fakeTodo);

          expect(isTodoCreated, isTrue);

          final todos = await todosDatabaseHelper.todos(3);

          expect(todos, isEmpty);
        },
      );
    });

    //
    group("update method", () {
      //
      test('isDone property should be true after update', () async {
        final isTodoCreated = await todosDatabaseHelper.createTodo(fakeTodo);

        expect(isTodoCreated, isTrue);

        List<Todo> todos = await todosDatabaseHelper.todos(1);
        //
        expect(todos, isNotEmpty);

        expect(todos.first.isDone, isFalse);

        final updatedTodo = fakeTodo.copyWith(isDone: true);

        final updateTodo = await todosDatabaseHelper.updateTodo(updatedTodo);

        expect(updateTodo, isTrue);

        todos = await todosDatabaseHelper.todos(1);

        expect(todos.first.isDone, isTrue);
      });
    });

    //
    group("delete method", () {
      //
      test('delete method should successfully delete created todo', () async {
        final isTodoCreated = await todosDatabaseHelper.createTodo(fakeTodo);

        expect(isTodoCreated, isTrue);

        List<Todo> todos = await todosDatabaseHelper.todos(1);
        //
        expect(todos, isNotEmpty);

        final delete = await todosDatabaseHelper.deleteTodo(fakeTodo.id);

        expect(delete, isTrue);

        todos = await todosDatabaseHelper.todos(1);

        expect(todos, isEmpty);
      });
    });
  });
}
