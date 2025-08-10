import 'package:flutter/material.dart';
import 'package:todo_youtube/src/features/todos/widgets/todos_configuration_widget.dart';

class MaterialContext extends StatefulWidget {
  const MaterialContext({super.key});

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return MaterialApp(
      home: TodosConfigurationWidget(),
      builder: (context, child) => MediaQuery(
        data: mediaQuery.copyWith(textScaler: TextScaler.linear(mediaQuery.textScaler.scale(1))),
        child: child!,
      ),
    );
  }
}