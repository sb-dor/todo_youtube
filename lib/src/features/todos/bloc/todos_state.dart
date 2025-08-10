part of 'todos_bloc.dart';

sealed class TodosState {
  const TodosState();

  const factory TodosState.initial() = TodosInitialState;

  const factory TodosState.inProgress() = TodosInProgressState;

  const factory TodosState.error() = TodosErrorState;

  const factory TodosState.completed(final List<Todo> todos) = TodosCompletedState;
}

final class TodosInitialState extends TodosState {
  const TodosInitialState();
}

final class TodosInProgressState extends TodosState {
  const TodosInProgressState();
}

final class TodosErrorState extends TodosState {
  const TodosErrorState();
}

final class TodosCompletedState extends TodosState {
  const TodosCompletedState(this.todos);

  final List<Todo> todos;
}
