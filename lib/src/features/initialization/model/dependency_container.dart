import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:todo_youtube/src/common/database/app_database.dart';
import 'package:todo_youtube/src/features/todos/data/todos_repository.dart';

class DependencyContainer {
  //
  DependencyContainer({
    required this.logger,
    required this.appDatabase,
    required this.todosRepository,
  });

  final Logger logger;

  final AppDatabase appDatabase;

  final ITodosRepository todosRepository;
}

// it's not necessary for now
@visibleForTesting
base class TestDependencyContainer implements DependencyContainer {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
