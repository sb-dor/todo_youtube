part of 'todos_bloc.dart';

sealed class TodosState {
  const TodosState();

  const factory TodosState.initial() = TodosInitialState;

  const factory TodosState.inProgress() = TodosInProgressState;

  const factory TodosState.error() = TodosErrorState;

  const factory TodosState.completed(
    final List<Todo> todos,
    final UserModel model,
  ) = TodosCompletedState;

  int get getRemainingTodosLength => switch (this) {
    final TodosCompletedState state =>
      state.todos.where((el) => !el.isDone).toList().length,
    _ => 0,
  };
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
  const TodosCompletedState(this.todos, this.userModel);

  final List<Todo> todos;
  final UserModel userModel;
}
