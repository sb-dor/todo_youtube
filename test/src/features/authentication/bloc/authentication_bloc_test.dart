import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_youtube/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_repository.dart';

import '../../../../fakes/fake_user.dart';
import '../data/authentication_repository_test.mocks.dart';

void main() {
  late MockIAuthenticationDatasource mockIAuthenticationRemoteDatasource;
  late MockIAuthenticationDatasource mockIAuthenticationLocalDatasource;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  late IAuthenticationRepository authenticationRepository;
  late AuthenticationBloc authenticationBloc;

  setUp(() {
    mockIAuthenticationRemoteDatasource = MockIAuthenticationDatasource();
    mockIAuthenticationLocalDatasource = MockIAuthenticationDatasource();
    mockInternetConnectionChecker = MockInternetConnectionChecker();

    authenticationRepository = AuthenticationRepositoryImpl(
      authenticationRemoteDatasource: mockIAuthenticationRemoteDatasource,
      authenticationLocalDatasource: mockIAuthenticationLocalDatasource,
      internetConnectionChecker: mockInternetConnectionChecker,
    );
  });

  tearDown(() {
    authenticationBloc.close();
  });

  group('Authentication Bloc', () {
    //
    group('login event', () {
      //
      test('Event should successfully emit AuthenticationState', () async {
        //
        when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(
          mockIAuthenticationLocalDatasource.login(name: fakeUser.name, email: fakeUser.email),
        ).thenAnswer((_) async => fakeUser);

        authenticationBloc = AuthenticationBloc(
          iAuthenticationRepository: authenticationRepository,
          logger: Logger(),
        );

        authenticationBloc.add(
          AuthenticationEvent.login(name: fakeUser.name, email: fakeUser.email),
        );

        await expectLater(
          authenticationBloc.stream,
          emitsInOrder([
            isA<Authentication$InProgressState>(),
            isA<Authentication$AuthenticatedState>().having(
              (state) => state.userModel,
              'userModel',
              allOf([isNotNull]),
            ),
          ]),
        );

        verify(
          mockIAuthenticationLocalDatasource.login(name: fakeUser.name, email: fakeUser.email),
        ).called(1);
      });

      //
      test('Event should throw an error due to a local database error', () async {
        //
        when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(
          mockIAuthenticationLocalDatasource.login(name: fakeUser.name, email: fakeUser.email),
        ).thenThrow(Exception());

        authenticationBloc = AuthenticationBloc(
          iAuthenticationRepository: authenticationRepository,
          logger: Logger(),
        );

        authenticationBloc.add(
          AuthenticationEvent.login(name: fakeUser.name, email: fakeUser.email),
        );

        await expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<Authentication$InProgressState>(), isA<Authentication$ErrorState>()]),
        );

        verify(
          mockIAuthenticationLocalDatasource.login(name: fakeUser.name, email: fakeUser.email),
        ).called(1);
      });

      //
      test('Event should emit initial state de to a nullable user', () async {
        //
        when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(
          mockIAuthenticationLocalDatasource.login(name: fakeUser.name, email: fakeUser.email),
        ).thenAnswer((_) async => null);

        authenticationBloc = AuthenticationBloc(
          iAuthenticationRepository: authenticationRepository,
          logger: Logger(),
        );

        authenticationBloc.add(
          AuthenticationEvent.login(name: fakeUser.name, email: fakeUser.email),
        );

        await expectLater(
          authenticationBloc.stream,
          emitsInOrder([isA<Authentication$InProgressState>(), isA<Authentication$InitialState>()]),
        );

        verify(
          mockIAuthenticationLocalDatasource.login(name: fakeUser.name, email: fakeUser.email),
        ).called(1);
      });
    });

    //
    group('delete user event', () {
      //
      test('event should delete user and then should emit initial state', () async {
        //
        when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(mockIAuthenticationLocalDatasource.deleteUser(1)).thenAnswer((_) async => true);
        //
        authenticationBloc = AuthenticationBloc(
          iAuthenticationRepository: authenticationRepository,
          logger: Logger(),
          initialState: Authentication$AuthenticatedState(fakeUser),
        );

        authenticationBloc.add(AuthenticationEvent.deleteUser());

        await expectLater(authenticationBloc.stream, emits(isA<Authentication$InitialState>()));
        verify(mockIAuthenticationLocalDatasource.deleteUser(1)).called(1);
      });

      //
      test('event should emit error state due to "false" value', () async {
        //
        when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(mockIAuthenticationLocalDatasource.deleteUser(1)).thenAnswer((_) async => false);
        //
        authenticationBloc = AuthenticationBloc(
          iAuthenticationRepository: authenticationRepository,
          logger: Logger(),
          initialState: Authentication$AuthenticatedState(fakeUser),
        );

        authenticationBloc.add(AuthenticationEvent.deleteUser());

        await expectLater(authenticationBloc.stream, emits(isA<Authentication$ErrorState>()));
        verify(mockIAuthenticationLocalDatasource.deleteUser(1)).called(1);
      });

      //
      test('event should emit nothing due the initial state', () async {
        //
        authenticationBloc = AuthenticationBloc(
          iAuthenticationRepository: authenticationRepository,
          logger: Logger(),
          initialState: Authentication$InitialState(),
        );

        authenticationBloc.add(AuthenticationEvent.deleteUser());

        expectLater(authenticationBloc.state, isA<Authentication$InitialState>());
      });
    });

    //
    group('logout event', () {
      //
      test('event should logout user and then should emit initial state', () async {
        //
        when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(mockIAuthenticationLocalDatasource.logout(1)).thenAnswer((_) async => true);
        //
        authenticationBloc = AuthenticationBloc(
          iAuthenticationRepository: authenticationRepository,
          logger: Logger(),
          initialState: Authentication$AuthenticatedState(fakeUser),
        );

        authenticationBloc.add(AuthenticationEvent.logout());

        await expectLater(authenticationBloc.stream, emits(isA<Authentication$InitialState>()));
        verify(mockIAuthenticationLocalDatasource.logout(1)).called(1);
      });

      //
      test('event should emit error state due to "false" value', () async {
        //
        when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
        when(mockIAuthenticationLocalDatasource.logout(1)).thenAnswer((_) async => false);
        //
        authenticationBloc = AuthenticationBloc(
          iAuthenticationRepository: authenticationRepository,
          logger: Logger(),
          initialState: Authentication$AuthenticatedState(fakeUser),
        );

        authenticationBloc.add(AuthenticationEvent.logout());

        await expectLater(authenticationBloc.stream, emits(isA<Authentication$ErrorState>()));
        verify(mockIAuthenticationLocalDatasource.logout(1)).called(1);
      });

      //
      test('event should emit nothing due the initial state', () async {
        //
        authenticationBloc = AuthenticationBloc(
          iAuthenticationRepository: authenticationRepository,
          logger: Logger(),
          initialState: Authentication$InitialState(),
        );

        authenticationBloc.add(AuthenticationEvent.logout());

        expectLater(authenticationBloc.state, isA<Authentication$InitialState>());
      });
    });
  });
}
