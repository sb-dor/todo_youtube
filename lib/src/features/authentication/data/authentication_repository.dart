import 'package:todo_youtube/src/common/internet_connection_checker.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_datasource.dart';
import 'package:todo_youtube/src/features/authentication/model/user_model.dart';

abstract interface class IAuthenticationRepository {
  //
  Future<UserModel?> login({
    required final String name,
    required final String email,
    final String? surname,
  });

  Future<bool> deleteUser(int id);

  Future<bool> logout(int id);
}

final class AuthenticationRepositoryImpl implements IAuthenticationRepository {
  AuthenticationRepositoryImpl({
    required final IAuthenticationDatasource authenticationRemoteDatasource,
    required final IAuthenticationDatasource authenticationLocalDatasource,
    required final InternetConnectionChecker internetConnectionChecker,
  }) : _authenticationRemoteDatasource = authenticationRemoteDatasource,
       _authenticationLocalDatasource = authenticationLocalDatasource,
       _internetConnectionChecker = internetConnectionChecker;

  final IAuthenticationDatasource _authenticationRemoteDatasource;
  final IAuthenticationDatasource _authenticationLocalDatasource;
  final InternetConnectionChecker _internetConnectionChecker;

  @override
  Future<UserModel?> login({
    required String name,
    required String email,
    String? surname,
  }) async {
    // if (await _internetConnectionChecker.hasAccessToInternet()) {
    //   return _authenticationRemoteDatasource.login(name: name, email: email, surname: surname);
    // } else {
    return _authenticationLocalDatasource.login(
      name: name,
      email: email,
      surname: surname,
    );
    // }
  }

  @override
  Future<bool> deleteUser(int id) async {
    // if (await _internetConnectionChecker.hasAccessToInternet()) {
    //   return _authenticationRemoteDatasource.deleteUser(id);
    // } else {
    return _authenticationLocalDatasource.deleteUser(id);
    // }
  }

  @override
  Future<bool> logout(int id) async {
    // if (await _internetConnectionChecker.hasAccessToInternet()) {
    //   return _authenticationRemoteDatasource.logout(id);
    // } else {
    return _authenticationLocalDatasource.logout(id);
    // }
  }
}
