import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:todo_youtube/src/features/todos/data/todos_repository.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

part 'todos_event.dart';

part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc({
    required ITodosRepository iTodosRepository,
    required Logger logger,
    TodosState? initialState,
  }) : _iTodosRepository = iTodosRepository,
       _logger = logger,
       super(initialState ?? TodosState.initial()) {
    //

    on<TodosEvent>(
      (event, emit) => switch (event) {
        final _TodosLoadEvent event => _todosLoadEvent(event, emit),
        final _TodosCreateTodoEvent event => _todosCreateTodoEvent(event, emit),
        final _TodosDeleteTodoEvent event => _todosDeleteTodoEvent(event, emit),
        final _TodosDoneTodoEvent event => _todosDoneTodoEvent(event, emit),
      },
    );
  }

  final ITodosRepository _iTodosRepository;
  final Logger _logger;

  void _todosLoadEvent(_TodosLoadEvent event, Emitter<TodosState> emit) async {
    try {
      emit(TodosState.inProgress());

      final todos = await _iTodosRepository.todos();

      _logger.log(Level.debug, "Count of coming todos: ${todos.length}");

      emit(TodosState.completed(todos));
    } catch (error, stackTrace) {
      emit(TodosState.error());
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _todosCreateTodoEvent(_TodosCreateTodoEvent event, Emitter<TodosState> emit) async {
    if (state is! TodosCompletedState) return;

    final newTodo = Todo(todo: event.todo, isDone: false, createdAt: DateTime.now());

    final createdTodo = await _iTodosRepository.createTodo(newTodo);

    if (createdTodo) {
      final todos = List.of((state as TodosCompletedState).todos);

      todos.add(newTodo);

      emit(TodosState.completed(todos));
    }
  }

  void _todosDeleteTodoEvent(_TodosDeleteTodoEvent event, Emitter<TodosState> emit) async {
    if (state is! TodosCompletedState) return;

    final deleteTodo = await _iTodosRepository.deleteTodo(event.todo.id);

    if (deleteTodo) {
      final todos = List.of((state as TodosCompletedState).todos);

      todos.removeWhere((el) => el.id == event.todo.id);

      emit(TodosState.completed(todos));
    }
  }

  void _todosDoneTodoEvent(_TodosDoneTodoEvent event, Emitter<TodosState> emit) async {
    if (state is! TodosCompletedState) return;

    final updatedTodo = event.todo.copyWith(isDone: !event.todo.isDone);

    final update = await _iTodosRepository.updateTodo(updatedTodo);

    if (update) {
      final todos = List.of((state as TodosCompletedState).todos);

      final index = todos.indexWhere((el) => el.id == updatedTodo.id);

      if (index != -1) {
        todos[index] = updatedTodo;
        emit(TodosState.completed(todos));
      }
    }
  }
}
