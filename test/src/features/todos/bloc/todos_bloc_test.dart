import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_youtube/src/features/todos/bloc/todos_bloc.dart';
import 'package:todo_youtube/src/features/todos/data/todos_repository.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

import '../../../../fakes/fake_todo.dart';
import '../../../../fakes/fake_user.dart';
import '../data/todos_repository_test.mocks.dart';

void main() {
  late MockITodosDatasource todoRemoteDatasource;
  late MockITodosDatasource todoLocalDatasource;
  late MockInternetConnectionChecker internetConnectionChecker;

  late ITodosRepository todosRepository;
  late TodosBloc todosBloc;

  final logger = Logger();

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

  tearDown(() {
    todosBloc.close();
  });

  group('Todos Bloc', () {
    //
    group("TodosLoadEvent test", () {
      //
      test('event should successfully emit completed state with list of todos', () {
        //
        when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(todoLocalDatasource.todos(fakeUser.id)).thenAnswer((_) async => [fakeTodo]);

        todosBloc = TodosBloc(iTodosRepository: todosRepository, logger: logger);

        todosBloc.add(TodosEvent.load(fakeUser));

        expectLater(
          todosBloc.stream,
          emitsInOrder([
            isA<TodosInProgressState>(),
            isA<TodosCompletedState>().having(
              (data) => data.todos,
              'todos',
              allOf([isNotEmpty, isA<List<Todo>>()]),
            ),
          ]),
        );
      });

      //
      //
      test('event should emit error state due to a local error', () {
        //
        when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(todoLocalDatasource.todos(fakeUser.id)).thenThrow(Exception());

        todosBloc = TodosBloc(iTodosRepository: todosRepository, logger: logger);

        todosBloc.add(TodosEvent.load(fakeUser));

        expectLater(
          todosBloc.stream,
          emitsInOrder([isA<TodosInProgressState>(), isA<TodosErrorState>()]),
        );
      });
    });

    //
    group('TodosCreateTodoEvent test', () {
      //
      test('event should successfully create todo', () {
        when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(todoLocalDatasource.createTodo(any)).thenAnswer((_) async => true);

        todosBloc = TodosBloc(
          iTodosRepository: todosRepository,
          logger: logger,
          initialState: TodosState.completed(<Todo>[], fakeUser),
        );

        expect(
          todosBloc.state,
          isA<TodosCompletedState>().having((data) => data.todos, 'todos is empty', isEmpty),
        );

        todosBloc.add(TodosEvent.createTodo(fakeTodo.todo));

        expectLater(
          todosBloc.stream,
          emits(
            isA<TodosCompletedState>().having(
              (data) => data.todos,
              'todos is not empty',
              isNotEmpty,
            ),
          ),
        );
      });

      //
      test('event should stop executing the code if state is not completed', () async {
        //
        todosBloc = TodosBloc(
          iTodosRepository: todosRepository,
          logger: logger,
          initialState: TodosState.initial(),
        );

        todosBloc.add(TodosEvent.createTodo(fakeTodo.todo));

        expect(todosBloc.state, isA<TodosInitialState>());
      });


      //
      test('event should emit error state due to a local error', () {
        //
        when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(todoLocalDatasource.createTodo(any)).thenThrow(Exception());

        todosBloc = TodosBloc(
          iTodosRepository: todosRepository,
          logger: logger,
          initialState: TodosCompletedState(<Todo>[], fakeUser),
        );

        todosBloc.add(TodosEvent.createTodo(fakeTodo.todo));

        expectLater(todosBloc.stream, emits(isA<TodosErrorState>()));
      });
    });

    //
    group('TodosDeleteTodoEvent', () {
      //
      test('event should successfully delete todo from list of todos', () {
        //
        when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(todoLocalDatasource.deleteTodo(fakeTodo.id)).thenAnswer((_) async => true);

        todosBloc = TodosBloc(
          iTodosRepository: todosRepository,
          logger: logger,
          initialState: TodosState.completed(<Todo>[fakeTodo], fakeUser),
        );

        expect(
          todosBloc.state,
          isA<TodosCompletedState>().having(
            (data) => data.todos,
            'todos list is not empty',
            isNotEmpty,
          ),
        );

        todosBloc.add(TodosEvent.deleteTodo(fakeTodo));

        expectLater(
          todosBloc.stream,
          emits(
            isA<TodosCompletedState>().having(
              (data) => data.todos,
              'todos list is empty now',
              isEmpty,
            ),
          ),
        );
      });

      //
      test('event should stop executing the code if state is not completed', () async {
        //
        todosBloc = TodosBloc(
          iTodosRepository: todosRepository,
          logger: logger,
          initialState: TodosState.initial(),
        );

        todosBloc.add(TodosEvent.deleteTodo(fakeTodo));

        expect(todosBloc.state, isA<TodosInitialState>());
      });


      //
      test('event should emit error state due to a local error', () {
        //
        when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(todoLocalDatasource.deleteTodo(any)).thenThrow(Exception());

        todosBloc = TodosBloc(
          iTodosRepository: todosRepository,
          logger: logger,
          initialState: TodosCompletedState(<Todo>[], fakeUser),
        );

        todosBloc.add(TodosEvent.deleteTodo(fakeTodo));

        expectLater(todosBloc.stream, emits(isA<TodosErrorState>()));
      });
    });

    //
    group('TodosDoneTodoEvent', () {
      //
      test('event should successfully finish todo (mark as done)', () async {
        //
        when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(todoLocalDatasource.updateTodo(any)).thenAnswer((_) async => true);

        final listOfTodos = <Todo>[fakeTodo];

        todosBloc = TodosBloc(
          iTodosRepository: todosRepository,
          logger: logger,
          initialState: TodosCompletedState(listOfTodos, fakeUser),
        );
        //

        expect(
          todosBloc.state,
          isA<TodosCompletedState>()
              .having(
                (data) => data.todos,
                'todos list is not empty and first element is not done yet',
                isNotEmpty,
              )
              .having((data) => data.todos.first.isDone, 'first element is not done', isFalse),
        );

        todosBloc.add(TodosEvent.doneTodo(fakeTodo));

        expectLater(
          todosBloc.stream,
          emits(
            isA<TodosCompletedState>()
                .having(
                  (data) => data.todos,
                  'todos list is not empty and first element is not done yet',
                  isNotEmpty,
                )
                .having((data) => data.todos.first.isDone, 'first element is not done', isTrue),
          ),
        );
      });

      //
      test('event should not finish todo due to a local error (emits nothing)', () async {
        //
        when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(todoLocalDatasource.updateTodo(any)).thenAnswer((_) async => false);

        final listOfTodos = <Todo>[fakeTodo];

        todosBloc = TodosBloc(
          iTodosRepository: todosRepository,
          logger: logger,
          initialState: TodosCompletedState(listOfTodos, fakeUser),
        );
        //

        expect(
          todosBloc.state,
          isA<TodosCompletedState>()
              .having(
                (data) => data.todos,
                'todos list is not empty and first element is not done yet',
                isNotEmpty,
              )
              .having((data) => data.todos.first.isDone, 'first element is not done', isFalse),
        );

        todosBloc.add(TodosEvent.doneTodo(fakeTodo));

        expectLater(todosBloc.state, isA<TodosCompletedState>());
      });

      //
      test('event should emit error state due to a local error', () {
        //
        when(internetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(todoLocalDatasource.updateTodo(any)).thenThrow(Exception());

        todosBloc = TodosBloc(
          iTodosRepository: todosRepository,
          logger: logger,
          initialState: TodosCompletedState(<Todo>[], fakeUser),
        );

        todosBloc.add(TodosEvent.doneTodo(fakeTodo));

        expectLater(todosBloc.stream, emits(isA<TodosErrorState>()));
      });
    });
  });
}
