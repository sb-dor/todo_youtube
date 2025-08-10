import 'package:flutter/material.dart';
import 'package:todo_youtube/src/features/initialization/model/dependency_container.dart';
import 'package:todo_youtube/src/features/initialization/widget/dependencies_scope.dart';

import 'material_context.dart';

class RootContext extends StatelessWidget {
  const RootContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(dependencies: dependencyContainer, child: MaterialContext());
  }
}
