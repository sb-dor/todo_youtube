import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Todo {
  Todo({
    String? tempId,
    required this.todo,
    required this.isDone,
    required this.createdAt,
    this.updatedAt,
  }) : id = tempId ?? const Uuid().v4();

  factory Todo.fromJson(final Map<String, Object?> json) {
    return Todo(
      todo: json['todo'] as String,
      isDone: json['is_done'] as bool,
      tempId: json['id'] as String,
      createdAt: json['created_at'] as DateTime,
    );
  }

  final String id;
  final bool isDone;
  final String todo;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "is_done": isDone,
      "todo": todo,
      "created_at": createdAt.toLocal().toIso8601String(),
    };
  }

  Todo copyWith({
    String? todo,
    bool? isDone,
    DateTime? createdAt,
    ValueGetter<DateTime?>? updatedAt, // Todo.copyWith(updatedAt: () => null)
  }) => Todo(
    tempId: id,
    todo: todo ?? this.todo,
    isDone: isDone ?? this.isDone,
    createdAt: this.createdAt,
    updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
  );
}
