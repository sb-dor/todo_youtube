import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:todo_youtube/src/features/todos/data/todos_repository.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

part 'todos_event.dart';

part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc({required ITodosRepository iTodosRepository, TodosState? initialState})
    : _iTodosRepository = iTodosRepository,
      super(initialState ?? TodosState.initial()) {
    //

    on<TodosEvent>(
      (event, emit) => switch (event) {
        final _TodosLoadEvent event => _todosLoadEvent(event, emit),
        final _TodosDeleteTodoEvent event => _todosDeleteTodoEvent(event, emit),
      },
    );
  }

  final ITodosRepository _iTodosRepository;

  void _todosLoadEvent(_TodosLoadEvent event, Emitter<TodosState> emit) async {
    try {
      emit(TodosState.inProgress());

      final todos = await _iTodosRepository.todos();

      emit(TodosState.completed(todos));
    } catch (error, stackTrace) {
      emit(TodosState.error());
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  void _todosDeleteTodoEvent(_TodosDeleteTodoEvent event, Emitter<TodosState> emit) async {}
}
