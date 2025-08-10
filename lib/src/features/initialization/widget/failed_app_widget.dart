import 'package:flutter/material.dart';

class FailedAppWidget extends StatefulWidget {
  const FailedAppWidget({super.key});

  @override
  State<FailedAppWidget> createState() => _FailedAppWidgetState();
}

class _FailedAppWidgetState extends State<FailedAppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: Text("App was not started"))),
    );
  }
}
