import 'package:uuid/uuid.dart';

class Todo {
  Todo({required this.todo, required this.isDone, String? tempId})
    : id = tempId ?? const Uuid().v4();

  factory Todo.fromJson(final Map<String, Object?> json) {
    return Todo(
      todo: json['todo'] as String,
      isDone: json['is_done'] as bool,
      tempId: json['id'] as String,
    );
  }

  final String id;
  final bool isDone;
  final String todo;

  Map<String, Object?> toJson() {
    return {"id": id, "is_done": isDone, "todo": todo};
  }
}
