import 'package:flutter/material.dart';
import 'package:todo_youtube/src/features/todos/models/todo.dart';

class TodoWidget extends StatelessWidget {
  const TodoWidget({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(),
      child: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: Row(
          children: [
            Checkbox(value: todo.isDone, onChanged: (value) {}),
            Expanded(child: Text(todo.todo)),
            IconButton(onPressed: () {}, icon: Icon(Icons.close)),
          ],
        ),
      ),
    );
  }
}
