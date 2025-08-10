part of "todos_bloc.dart";

sealed class TodosEvent {
  const TodosEvent();

  const factory TodosEvent.load() = _TodosLoadEvent;

  const factory TodosEvent.deleteTodo() = _TodosDeleteTodoEvent;
}

final class _TodosLoadEvent extends TodosEvent {
  const _TodosLoadEvent();
}

final class _TodosDeleteTodoEvent extends TodosEvent {
  const _TodosDeleteTodoEvent();
}
