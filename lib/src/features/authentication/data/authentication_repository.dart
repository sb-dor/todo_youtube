import 'package:todo_youtube/src/features/authentication/model/user_model.dart';

abstract interface class IAuthenticationRepository {
  //
  Future<UserModel?> login({
    required final String name,
    required final String email,
    final String? surname,
  });

  Future<bool> logout(int id);
}

final class AuthenticationRepositoryImpl implements IAuthenticationRepository {
  @override
  Future<UserModel?> login({required String name, required String email, String? surname}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<bool> logout(int id) {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
