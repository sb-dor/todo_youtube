import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_youtube/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_repository.dart';
import 'package:todo_youtube/src/features/authentication/widgets/authentication_widget.dart';
import 'package:todo_youtube/src/features/initialization/model/dependency_container.dart';

import '../../../../fakes/fake_user.dart';
import '../../../../helper/test_widget_controller.dart';
import '../data/authentication_repository_test.mocks.dart';

void main() {
  late MockIAuthenticationDatasource authenticationRemoteDatasource;
  late MockIAuthenticationDatasource authenticationLocalDatasource;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  late final AuthenticationDependencyContainerTest dependencyContainerTest;
  late final AuthenticationBloc authenticationBloc;

  setUpAll(() {
    authenticationRemoteDatasource = MockIAuthenticationDatasource();
    authenticationLocalDatasource = MockIAuthenticationDatasource();
    mockInternetConnectionChecker = MockInternetConnectionChecker();

    final IAuthenticationRepository iAuthenticationRepository = AuthenticationRepositoryImpl(
      authenticationRemoteDatasource: authenticationRemoteDatasource,
      authenticationLocalDatasource: authenticationLocalDatasource,
      internetConnectionChecker: mockInternetConnectionChecker,
    );

    authenticationBloc = AuthenticationBloc(
      iAuthenticationRepository: iAuthenticationRepository,
      logger: Logger(),
    );

    dependencyContainerTest = AuthenticationDependencyContainerTest(authenticationBloc);
  });

  tearDownAll(() {
    authenticationBloc.close();
  });

  group('Authentication widget test', () {
    //
    testWidgets('Find Authentication title from widget', (tester) async {
      //
      await TestWidgetController(
        tester,
      ).pumpWidget(AuthenticationWidget(), dependencies: dependencyContainerTest);

      final findTitle = find.text("Authentication");

      expect(findTitle, findsOneWidget);
    });

    //
    testWidgets("Finding Authentication title while user clicks on Login button", (tester) async {
      when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(
        authenticationLocalDatasource.login(name: fakeUser.name, email: fakeUser.email),
      ).thenAnswer((_) async => fakeUser);

      //
      await TestWidgetController(
        tester,
      ).pumpWidget(AuthenticationWidget(), dependencies: dependencyContainerTest);

      final nameTextField = find.byKey(ValueKey<String>("name_text_field"));

      final emailTextField = find.byKey(ValueKey<String>("email_text_field"));

      final loginButton = find.byKey(ValueKey<String>("login_button"));

      expect(nameTextField, findsOneWidget);

      expect(emailTextField, findsOneWidget);

      expect(loginButton, findsOneWidget);

      await tester.runAsync(() async {
        await tester.enterText(nameTextField, fakeUser.name);

        await tester.enterText(emailTextField, fakeUser.email);

        await tester.tap(loginButton);

        await tester.pumpAndSettle();

        final authenticatedTitle = find.text('Authenticated!');
        //
        expect(authenticatedTitle, findsOneWidget);
      });
    });
  });
}

final class AuthenticationDependencyContainerTest extends TestDependencyContainer {
  AuthenticationDependencyContainerTest(this._authenticationBloc);

  final AuthenticationBloc _authenticationBloc;

  @override
  AuthenticationBloc get authenticationBloc => _authenticationBloc;
}
