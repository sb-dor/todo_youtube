import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Todo {
  Todo({
    String? tempId,
    required this.todo,
    required this.isDone,
    required this.createdAt,
    required this.userId,
    this.updatedAt,
  }) : id = tempId ?? const Uuid().v4();

  factory Todo.fromJson(final Map<String, Object?> json) {
    return Todo(
      todo: json['todo'] as String,
      isDone: json['is_done'] as bool,
      tempId: json['id'] as String,
      userId: json['user_id'] as int,
      createdAt: json['created_at'] as DateTime,
    );
  }

  final String id;
  final bool isDone;
  final String todo;
  final DateTime createdAt;
  final int? userId;
  final DateTime? updatedAt;

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "is_done": isDone,
      "todo": todo,
      "user_id": userId,
      "created_at": createdAt.toLocal().toIso8601String(),
    };
  }

  Todo copyWith({
    String? todo,
    bool? isDone,
    DateTime? createdAt,
    ValueGetter<int?>? userId,
    ValueGetter<DateTime?>? updatedAt, // Todo.copyWith(updatedAt: () => null)
  }) => Todo(
    tempId: id,
    todo: todo ?? this.todo,
    isDone: isDone ?? this.isDone,
    createdAt: this.createdAt,
    userId: userId != null ? userId() : this.userId,
    updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
  );
}
