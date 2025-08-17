// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class TodosTable extends Table with TableInfo<TodosTable, TodosTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TodosTable(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> todo = GeneratedColumn<String>(
    'todo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, todo, isDone, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos_table';
  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  TodosTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodosTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      todo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}todo'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  TodosTable createAlias(String alias) {
    return TodosTable(attachedDatabase, alias);
  }
}

class TodosTableData extends DataClass implements Insertable<TodosTableData> {
  final String id;
  final String todo;
  final bool isDone;
  final DateTime createdAt;
  const TodosTableData({
    required this.id,
    required this.todo,
    required this.isDone,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['todo'] = Variable<String>(todo);
    map['is_done'] = Variable<bool>(isDone);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TodosTableCompanion toCompanion(bool nullToAbsent) {
    return TodosTableCompanion(
      id: Value(id),
      todo: Value(todo),
      isDone: Value(isDone),
      createdAt: Value(createdAt),
    );
  }

  factory TodosTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodosTableData(
      id: serializer.fromJson<String>(json['id']),
      todo: serializer.fromJson<String>(json['todo']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'todo': serializer.toJson<String>(todo),
      'isDone': serializer.toJson<bool>(isDone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TodosTableData copyWith({
    String? id,
    String? todo,
    bool? isDone,
    DateTime? createdAt,
  }) => TodosTableData(
    id: id ?? this.id,
    todo: todo ?? this.todo,
    isDone: isDone ?? this.isDone,
    createdAt: createdAt ?? this.createdAt,
  );
  TodosTableData copyWithCompanion(TodosTableCompanion data) {
    return TodosTableData(
      id: data.id.present ? data.id.value : this.id,
      todo: data.todo.present ? data.todo.value : this.todo,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodosTableData(')
          ..write('id: $id, ')
          ..write('todo: $todo, ')
          ..write('isDone: $isDone, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, todo, isDone, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodosTableData &&
          other.id == this.id &&
          other.todo == this.todo &&
          other.isDone == this.isDone &&
          other.createdAt == this.createdAt);
}

class TodosTableCompanion extends UpdateCompanion<TodosTableData> {
  final Value<String> id;
  final Value<String> todo;
  final Value<bool> isDone;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TodosTableCompanion({
    this.id = const Value.absent(),
    this.todo = const Value.absent(),
    this.isDone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodosTableCompanion.insert({
    required String id,
    required String todo,
    required bool isDone,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       todo = Value(todo),
       isDone = Value(isDone),
       createdAt = Value(createdAt);
  static Insertable<TodosTableData> custom({
    Expression<String>? id,
    Expression<String>? todo,
    Expression<bool>? isDone,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (todo != null) 'todo': todo,
      if (isDone != null) 'is_done': isDone,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodosTableCompanion copyWith({
    Value<String>? id,
    Value<String>? todo,
    Value<bool>? isDone,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TodosTableCompanion(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (todo.present) {
      map['todo'] = Variable<String>(todo.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosTableCompanion(')
          ..write('id: $id, ')
          ..write('todo: $todo, ')
          ..write('isDone: $isDone, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV1 extends GeneratedDatabase {
  DatabaseAtV1(QueryExecutor e) : super(e);
  late final TodosTable todosTable = TodosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todosTable];
  @override
  int get schemaVersion => 1;
}
