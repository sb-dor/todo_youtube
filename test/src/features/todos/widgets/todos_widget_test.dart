import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_youtube/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_repository.dart';
import 'package:todo_youtube/src/features/initialization/model/dependency_container.dart';
import 'package:todo_youtube/src/features/todos/data/todos_repository.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';
import 'package:todo_youtube/src/features/todos/widgets/todos_widget.dart';

import '../../../../fakes/fake_todo.dart';
import '../../../../fakes/fake_user.dart';
import '../../../../helper/test_widget_controller.dart';
import '../../authentication/data/authentication_repository_test.mocks.dart' as auth;
import '../data/todos_repository_test.mocks.dart';

void main() {
  late MockITodosDatasource todoRemoteDatasource;
  late MockITodosDatasource todoLocalDatasource;
  late auth.MockIAuthenticationDatasource authenticationRemoteDatasource;
  late auth.MockIAuthenticationDatasource authenticationLocalDatasource;
  late MockInternetConnectionChecker internetConnectionChecker;

  final logger = Logger();
  late AuthenticationBloc authenticationBloc;
  late final TodosTestDependencyContainer todosTestDependencyContainer;

  setUpAll(() {
    todoRemoteDatasource = MockITodosDatasource();
    todoLocalDatasource = MockITodosDatasource();
    internetConnectionChecker = MockInternetConnectionChecker();

    authenticationRemoteDatasource = auth.MockIAuthenticationDatasource();
    authenticationLocalDatasource = auth.MockIAuthenticationDatasource();

    final authenticationRepository = AuthenticationRepositoryImpl(
      authenticationRemoteDatasource: authenticationRemoteDatasource,
      authenticationLocalDatasource: authenticationLocalDatasource,
      internetConnectionChecker: internetConnectionChecker,
    );

    authenticationBloc = AuthenticationBloc(
      iAuthenticationRepository: authenticationRepository,
      logger: logger,
      initialState: Authentication$AuthenticatedState(fakeUser),
    );

    final todosRepository = TodosRepositoryImpl(
      todoRemoteDatasource: todoRemoteDatasource,
      todoLocalDatasource: todoLocalDatasource,
      internetConnectionChecker: internetConnectionChecker,
    );

    todosTestDependencyContainer = TodosTestDependencyContainer(
      authenticationBloc,
      todosRepository,
      logger,
    );
  });

  tearDownAll(() {
    authenticationBloc.close();
  });

  group('Todos widget', () {
    //
    testWidgets('find todo widget after adding new todo', (tester) async {
      when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(todoLocalDatasource.todos(fakeUser.id)).thenAnswer((_) async => <Todo>[]);
      when(todoLocalDatasource.createTodo(any)).thenAnswer((_) async => true);

      await TestWidgetController(
        tester,
      ).pumpWidget(TodosWidget(userModel: fakeUser), dependencies: todosTestDependencyContainer);

      await tester.pumpAndSettle();

      final todoTextField = find.byKey(ValueKey<String>('todo_text_field'));
      final addTodoButton = find.byKey(ValueKey<String>("add_todo_button"));

      expect(todoTextField, findsOneWidget);
      expect(addTodoButton, findsOneWidget);
      //
      await tester.enterText(todoTextField, 'New todo');

      await tester.tap(addTodoButton);

      await tester.pumpAndSettle();

      final findTodoWidgets = find.byWidgetPredicate(
        (el) =>
            el.key != null &&
            el.key is ValueKey<String> &&
            (el.key as ValueKey<String>).value.contains('todo_widget_'),
      );

      expect(findTodoWidgets, findsWidgets);
    });

    //
    testWidgets('find nothing after deleting  todo', (tester) async {
      when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(todoLocalDatasource.todos(fakeUser.id)).thenAnswer((_) async => <Todo>[fakeTodo]);
      when(todoLocalDatasource.deleteTodo(any)).thenAnswer((_) async => true);

      await TestWidgetController(
        tester,
      ).pumpWidget(TodosWidget(userModel: fakeUser), dependencies: todosTestDependencyContainer);

      await tester.pumpAndSettle();

      final findTodoDeleteButtons = find.byWidgetPredicate(
        (el) =>
            el.key != null &&
            el.key is ValueKey<String> &&
            (el.key as ValueKey<String>).value.contains('todo_delete_'),
      );

      expect(findTodoDeleteButtons, findsWidgets);
      //
      await tester.tap(findTodoDeleteButtons.first);

      await tester.pumpAndSettle();

      final findTodoDeleteButtonsAfterDelete = find.byWidgetPredicate(
        (el) =>
            el.key != null &&
            el.key is ValueKey<String> &&
            (el.key as ValueKey<String>).value.contains('todo_delete_'),
      );

      expect(findTodoDeleteButtonsAfterDelete, findsNothing);
    });
  });
}

final class TodosTestDependencyContainer extends TestDependencyContainer {
  TodosTestDependencyContainer(this._authenticationBloc, this._todosRepository, this._logger);

  final AuthenticationBloc _authenticationBloc;
  final ITodosRepository _todosRepository;
  final Logger _logger;

  @override
  AuthenticationBloc get authenticationBloc => _authenticationBloc;

  @override
  ITodosRepository get todosRepository => _todosRepository;

  @override
  Logger get logger => _logger;
}
