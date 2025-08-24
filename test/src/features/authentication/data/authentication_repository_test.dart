import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_youtube/src/common/internet_connection_checker.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_datasource.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_repository.dart';

import '../../../../fakes/fake_user.dart';
import 'authentication_repository_test.mocks.dart';

@GenerateMocks([IAuthenticationDatasource, InternetConnectionChecker])
void main() {
  late MockIAuthenticationDatasource mockRemoteDatasource;
  late MockIAuthenticationDatasource mockLocalDatasource;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  late IAuthenticationRepository authenticationRepository;

  setUp(() {
    mockRemoteDatasource = MockIAuthenticationDatasource();
    mockLocalDatasource = MockIAuthenticationDatasource();
    mockInternetConnectionChecker = MockInternetConnectionChecker();

    authenticationRepository = AuthenticationRepositoryImpl(
      authenticationRemoteDatasource: mockRemoteDatasource,
      authenticationLocalDatasource: mockLocalDatasource,
      internetConnectionChecker: mockInternetConnectionChecker,
    );
  });

  group('Authentication Repository', () {
    //
    test('login method should successfully return user after login', () async {
      //
      when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(
        mockLocalDatasource.login(name: fakeUser.name, email: fakeUser.email),
      ).thenAnswer((_) async => fakeUser);

      final user = await authenticationRepository.login(name: fakeUser.name, email: fakeUser.email);

      expect(user, isNotNull);
      verify(mockLocalDatasource.login(name: fakeUser.name, email: fakeUser.email)).called(1);
    });

    //
    test('deleteUser method should successfully delete user', () async {
      //
      when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(mockLocalDatasource.deleteUser(any)).thenAnswer((_) async => true);

      final delete = await authenticationRepository.deleteUser(1);

      expect(delete, isTrue);
      verify(mockLocalDatasource.deleteUser(any)).called(1);
    });

    //
    test('logout method should successfully log out user from device', () async {
      //
      when(mockInternetConnectionChecker.hasAccessToInternet()).thenAnswer((_) async => false);
      when(mockLocalDatasource.logout(any)).thenAnswer((_) async => true);


      final logout = await authenticationRepository.logout(1);

      expect(logout, isTrue);
      verify(mockLocalDatasource.logout(any)).called(1);
    });
  });
}
