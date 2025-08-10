import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:todo_youtube/src/features/initialization/model/dependency_container.dart';

// Future<CompositionRoot> compositionRoot() async {
//
// }

Future<DependencyContainer> createDependencies({required Logger logger}) async {
  return DependencyContainer(logger: logger);
}

Logger createAppLogger({required LogFilter logFilter}) {
  return Logger(
    filter: logFilter,
    printer: PrettyPrinter(
      methodCount: 2,
      // Number of method calls to be displayed
      errorMethodCount: 8,
      // Number of method calls if stacktrace is provided
      lineLength: 120,
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      // Should each log print contain a timestamp
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: ConsoleOutput(),
  );
}

final class NoOpLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false;
  }
}

// class CompositionRoot {
//   CompositionRoot(this.dependencyContainer);
//
//   final DependencyContainer dependencyContainer;
// }
