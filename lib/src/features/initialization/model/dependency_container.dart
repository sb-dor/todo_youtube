import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class DependencyContainer {
  //
  DependencyContainer({required this.logger});

  final Logger logger;
}

// it's not necessary for now
@visibleForTesting
base class TestDependencyContainer implements DependencyContainer {
  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}
