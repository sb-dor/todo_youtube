import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_youtube/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:todo_youtube/src/features/initialization/widget/dependencies_scope.dart';
import 'package:todo_youtube/src/features/todos/widgets/todos_widget.dart';

class AuthenticationWidget extends StatefulWidget {
  const AuthenticationWidget({super.key});

  @override
  State<AuthenticationWidget> createState() => _AuthenticationWidgetState();
}

class _AuthenticationWidgetState extends State<AuthenticationWidget> {
  late final AuthenticationBloc _authenticationBloc;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    _authenticationBloc = dependencies.authenticationBloc;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authentication")),
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        bloc: _authenticationBloc,
        listener: (context, state) {
          if (state is Authentication$AuthenticatedState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TodosWidget(userModel: state.userModel)),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              switch (state) {
                Authentication$InitialState() => SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          key: ValueKey<String>("name_text_field"),
                          controller: _nameController,
                          decoration: InputDecoration(hintText: "Name"),
                        ),
                        TextField(
                          key: ValueKey<String>("email_text_field"),
                          controller: _emailController,
                          decoration: InputDecoration(hintText: "Email"),
                        ),
                        TextField(
                          controller: _surnameController,
                          decoration: InputDecoration(hintText: "Surname"),
                        ),
                        ElevatedButton(
                          key: ValueKey<String>("login_button"),
                          onPressed: () {
                            final name = _nameController.text.trim();
                            final email = _emailController.text.trim();
                            final surname = _surnameController.text.trim();

                            if (name.isEmpty || email.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Fill required fields: name and email")),
                              );
                              return;
                            }

                            _authenticationBloc.add(
                              AuthenticationEvent.login(
                                name: name,
                                email: email,
                                surname: surname.isEmpty ? null : surname,
                              ),
                            );
                          },
                          child: Text("Login"),
                        ),
                      ],
                    ),
                  ),
                ),
                Authentication$InProgressState() => SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                Authentication$ErrorState() => SliverFillRemaining(
                  child: Center(
                    child: TextButton(onPressed: () {}, child: Text("Try again")),
                  ),
                ),
                Authentication$AuthenticatedState() => SliverFillRemaining(
                  child: Center(child: Text("Authenticated!")),
                ),
              },
            ],
          );
        },
      ),
    );
  }
}
