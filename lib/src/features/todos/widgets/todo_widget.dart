import 'package:flutter/material.dart';
import 'package:todo_youtube/src/features/todos/bloc/todos_bloc.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({super.key, required this.todo, required this.todosBloc});

  final Todo todo;
  final TodosBloc todosBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Row(
            children: [
              Checkbox(
                value: todo.isDone,
                onChanged: (value) {
                  todosBloc.add(TodosEvent.doneTodo(todo));
                },
              ),
              Expanded(child: Text(todo.todo)),
              IconButton(
                key: ValueKey<String>("todo_delete_${todo.id}"),
                onPressed: () {
                  todosBloc.add(TodosEvent.deleteTodo(todo));
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
