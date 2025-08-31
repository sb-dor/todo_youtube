import 'package:flutter/material.dart';
import 'package:todo_youtube/src/features/initialization/model/dependency_container.dart';

class DependenciesScope extends InheritedWidget {
  const DependenciesScope({
    super.key,
    required this.dependencies,
    required super.child,
  });

  static DependencyContainer of(BuildContext context) {
    final result = context
        .getElementForInheritedWidgetOfExactType<DependenciesScope>()
        ?.widget;
    final checkDep = result is DependenciesScope;
    assert(checkDep, 'No DependenciesScope found in context');
    return (result as DependenciesScope).dependencies;
  }

  final DependencyContainer dependencies;

  @override
  bool updateShouldNotify(DependenciesScope old) {
    return false;
  }
}
