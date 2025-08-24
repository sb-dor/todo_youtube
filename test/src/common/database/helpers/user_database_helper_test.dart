import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:todo_youtube/src/common/database/app_database.dart';
import 'package:todo_youtube/src/common/database/database_helpers/todos_database_helper.dart';
import 'package:todo_youtube/src/common/database/database_helpers/user_database_helper.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

import '../../../../fakes/fake_todo.dart';
import '../../../../fakes/fake_user.dart';

void main() {
  late AppDatabase appDatabase;
  late UserDatabaseHelper userDatabaseHelper;
  late TodosDatabaseHelper todosDatabaseHelper;

  setUp(() {
    appDatabase = AppDatabase(
      drift.DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
    );
    userDatabaseHelper = UserDatabaseHelper(appDatabase);
    todosDatabaseHelper = TodosDatabaseHelper(appDatabase: appDatabase, logger: Logger());
  });

  tearDown(() {
    appDatabase.close();
  });

  group('User Database Helper', () {
    //
    group('create method', () {
      //
      test('method should return or create user using email, name, surname', () async {
        //
        final user = userDatabaseHelper.createUser(
          name: fakeUser.name,
          email: fakeUser.email,
          surname: fakeUser.surname,
        );

        expect(user, completion(isNotNull));
      });
    });

    //
    group('delete method', () {
      //
      test('method should remove all data from user and todos table', () async {
        //

        final createUser = await userDatabaseHelper.createUser(
          name: fakeUser.name,
          email: fakeUser.email,
        );
        final createTodo = await todosDatabaseHelper.createTodo(fakeTodo);

        expect(createUser, isNotNull);
        expect(createTodo, isTrue);

        List<Todo> todos = await todosDatabaseHelper.todos(createUser.id);

        expect(todos, isNotEmpty);

        final deleteUser = await userDatabaseHelper.deleteUser(createUser.id);
        todos = await todosDatabaseHelper.todos(createUser.id);

        expect(deleteUser, isTrue);
        expect(todos, isEmpty);
      });
    });
  });
}
