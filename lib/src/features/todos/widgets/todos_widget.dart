part of 'todos_configuration_widget.dart';

class _TodosWidget extends StatefulWidget {
  const _TodosWidget();

  @override
  State<_TodosWidget> createState() => _TodosWidgetState();
}

class _TodosWidgetState extends State<_TodosWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your todo app", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: Center(child: SizedBox()),
    );
  }
}
