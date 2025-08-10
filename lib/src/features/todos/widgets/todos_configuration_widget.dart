import 'package:flutter/material.dart';

part 'todos_widget.dart';

class TodosConfigurationWidget extends StatefulWidget {
  const TodosConfigurationWidget({super.key});

  @override
  State<TodosConfigurationWidget> createState() => _TodosConfigurationWidgetState();
}

class _TodosConfigurationWidgetState extends State<TodosConfigurationWidget> {
  @override
  Widget build(BuildContext context) {
    return _TodosWidget();
  }
}
