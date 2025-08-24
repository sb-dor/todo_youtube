import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_youtube/src/common/database/database_helpers/user_database_helper.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_datasource.dart';

import '../../../../fakes/fake_user.dart';
import 'authentication_local_datasource_test.mocks.dart';

@GenerateMocks([UserDatabaseHelper])
void main() {
  late MockUserDatabaseHelper mockUserDatabaseHelper;
  late AuthenticationLocalDatasource localDatasource;

  setUp(() {
    mockUserDatabaseHelper = MockUserDatabaseHelper();
    localDatasource = AuthenticationLocalDatasource(userDatabaseHelper: mockUserDatabaseHelper);
  });

  group('Authentication Datasource', () {
    //
    group('login methods', () {
      //
      test('method should return user after login', () async {
        //
        when(
          mockUserDatabaseHelper.createUser(name: fakeUser.name, email: fakeUser.email),
        ).thenAnswer((_) async => fakeUser);

        final login = await localDatasource.login(name: fakeUser.name, email: fakeUser.email);

        expect(login, isNotNull);
        verify(
          mockUserDatabaseHelper.createUser(name: fakeUser.name, email: fakeUser.email),
        ).called(1);
      });

      //
      test('method should throw an exception after login', () async {
        //
        when(
          mockUserDatabaseHelper.createUser(name: fakeUser.name, email: fakeUser.email),
        ).thenThrow(Exception());

        expect(
          () => localDatasource.login(name: fakeUser.name, email: fakeUser.email),
          throwsA(isA<Exception>()),
        );
      });
    });

    //
    group('deleteUser method', () {
      //
      test('method should successfully delete user', () {
        //
        when(mockUserDatabaseHelper.deleteUser(any)).thenAnswer((_) async => true);

        final deleteUser = localDatasource.deleteUser(fakeUser.id);

        expect(deleteUser, completion(isTrue));
      });

      //
      test('method should throw an exception after deleting user', () {
        //
        when(mockUserDatabaseHelper.deleteUser(any)).thenThrow(Exception());

        expect(() => localDatasource.deleteUser(fakeUser.id), throwsA(isA<Exception>()));
      });
    });

    //
    group('logout method', () {
      //
      test('method should successfully return true after logout', () async {
        //
        final logout = await localDatasource.logout(fakeUser.id);
        
        expect(logout, isTrue);
      });
    });
  });
}
