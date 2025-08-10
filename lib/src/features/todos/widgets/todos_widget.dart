import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_youtube/src/features/initialization/widget/dependencies_scope.dart';
import 'package:todo_youtube/src/features/todos/bloc/todos_bloc.dart';
import 'package:todo_youtube/src/features/todos/widgets/todo_widget.dart';

class TodosWidget extends StatefulWidget {
  const TodosWidget({super.key});

  @override
  State<TodosWidget> createState() => _TodosWidgetState();
}

class _TodosWidgetState extends State<TodosWidget> {
  late final TodosBloc _todosBloc;
  final TextEditingController _todoTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final dependenciesScope = DependenciesScope.of(context);
    _todosBloc = TodosBloc(
      iTodosRepository: dependenciesScope.todosRepository,
      logger: dependenciesScope.logger,
    );
    _todosBloc.add(TodosEvent.load());
  }

  @override
  void dispose() {
    _todosBloc.close();
    _todoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        title: Text("Your todo app", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        bloc: _todosBloc,
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async => _todosBloc.add(TodosEvent.load()),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(15.0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _todoTextController,
                            decoration: InputDecoration(hintText: "Add new task"),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_todoTextController.text.trim().isEmpty) return;
                            _todosBloc.add(TodosEvent.createTodo(_todoTextController.text));
                            _todoTextController.clear();
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 10)),

                switch (state) {
                  TodosInitialState() => SliverFillRemaining(
                    child: Center(child: Text("Initialising")),
                  ),
                  TodosInProgressState() => SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  TodosErrorState() => SliverFillRemaining(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _todosBloc.add(TodosEvent.load());
                        },
                        child: Text("Error state - Refresh"),
                      ),
                    ),
                  ),
                  TodosCompletedState() => SliverList.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final todo = state.todos[index];
                      return TodoWidget(todo: todo, todosBloc: _todosBloc);
                    },
                  ),
                },
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      "Your remaining todos: ${state.getRemainingTodosLength}",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
