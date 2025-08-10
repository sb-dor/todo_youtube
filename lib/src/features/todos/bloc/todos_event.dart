part of "todos_bloc.dart";

sealed class TodosEvent {
  const TodosEvent();

  const factory TodosEvent.load() = _TodosLoadEvent;

  const factory TodosEvent.createTodo(final String todo) = _TodosCreateTodoEvent;

  const factory TodosEvent.deleteTodo(final Todo todo) = _TodosDeleteTodoEvent;

  const factory TodosEvent.doneTodo(final Todo todo) = _TodosDoneTodoEvent;
}

final class _TodosLoadEvent extends TodosEvent {
  const _TodosLoadEvent();
}

final class _TodosCreateTodoEvent extends TodosEvent {
  const _TodosCreateTodoEvent(this.todo);

  final String todo;
}

final class _TodosDeleteTodoEvent extends TodosEvent {
  const _TodosDeleteTodoEvent(this.todo);

  final Todo todo;
}

final class _TodosDoneTodoEvent extends TodosEvent {
  const _TodosDoneTodoEvent(this.todo);

  final Todo todo;
}
