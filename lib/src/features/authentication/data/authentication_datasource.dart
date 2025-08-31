import 'package:todo_youtube/src/common/database/database_helpers/user_database_helper.dart';
import 'package:todo_youtube/src/features/authentication/model/user_model.dart';

abstract interface class IAuthenticationDatasource {
  //
  Future<UserModel?> login({
    required final String name,
    required final String email,
    final String? surname,
  });

  Future<bool> deleteUser(int id);

  Future<bool> logout(int id);
}

final class AuthenticationRemoteDatasource
    implements IAuthenticationDatasource {
  @override
  Future<UserModel?> login({
    required String name,
    required String email,
    String? surname,
  }) => Future.value(null);

  @override
  Future<bool> deleteUser(int id) => Future.value(false);

  @override
  Future<bool> logout(int id) => Future.value(false);
}

final class AuthenticationLocalDatasource implements IAuthenticationDatasource {
  AuthenticationLocalDatasource({
    required UserDatabaseHelper userDatabaseHelper,
  }) : _userDatabaseHelper = userDatabaseHelper;

  final UserDatabaseHelper _userDatabaseHelper;

  @override
  Future<UserModel?> login({
    required String name,
    required String email,
    String? surname,
  }) => _userDatabaseHelper.createUser(
    name: name,
    email: email,
    surname: surname,
  );

  @override
  Future<bool> deleteUser(int id) => _userDatabaseHelper.deleteUser(id);

  @override
  Future<bool> logout(int id) async {
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }
}
