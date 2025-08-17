import 'package:flutter/material.dart';
import 'package:todo_youtube/src/features/authentication/widgets/authentication_widget.dart';
import 'package:todo_youtube/src/features/initialization/model/dependency_container.dart';
import 'package:todo_youtube/src/features/initialization/widget/dependencies_scope.dart';
import 'package:todo_youtube/src/features/todos/widgets/todos_widget.dart';

class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key, required this.dependencyContainer});

  final DependencyContainer dependencyContainer;

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return DependenciesScope(
      dependencies: widget.dependencyContainer,
      child: MaterialApp(
        home: AuthenticationWidget(),
        builder: (context, child) => MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.linear(mediaQuery.textScaler.scale(1))),
          child: child!,
        ),
      ),
    );
  }
}
