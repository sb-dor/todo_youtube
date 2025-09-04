import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_youtube/src/features/initialization/model/dependency_container.dart';
import 'package:todo_youtube/src/features/initialization/widget/dependencies_scope.dart';

class TestWidgetController {
  TestWidgetController(this._tester);

  final WidgetTester _tester;

  Future<void> pumpWidget(
    Widget child, {
    DependencyContainer? dependencies,
    bool wrappedWithMaterialApp = true,
  }) async {
    if (wrappedWithMaterialApp) {
      child = MaterialApp(home: child);
    }

    if (dependencies != null) {
      child = DependenciesScope(dependencies: dependencies, child: child);
    }

    await _tester.pumpWidget(child);
  }
}
