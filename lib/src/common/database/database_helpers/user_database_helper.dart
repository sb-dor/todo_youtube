import 'package:drift/drift.dart';
import 'package:todo_youtube/src/common/database/app_database.dart';
import 'package:todo_youtube/src/features/authentication/model/user_model.dart';

class UserDatabaseHelper {
  UserDatabaseHelper(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<UserModel> createUser({
    required final String name,
    required final String email,
    final String? surname,
  }) async {
    final userWhere = (_appDatabase.select(_appDatabase.userTable)
      ..where((el) => el.email.equals(email) & el.name.equals(name)));

    if (surname != null) {
      userWhere.where((el) => el.surname.contains(surname));
    }

    final user = await userWhere.getSingleOrNull();

    if (user != null) {
      return UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        surname: user.surname,
      );
    }

    final userTableData = UserTableCompanion(
      name: Value(name),
      email: Value(email),
      surname: Value(surname),
    );

    final userData = await _appDatabase
        .into(_appDatabase.userTable)
        .insertReturning(userTableData);

    return UserModel(
      id: userData.id,
      name: userData.name,
      email: userData.email,
      surname: userData.surname,
    );
  }

  Future<bool> deleteUser(int id) async {
    await (_appDatabase.delete(
      _appDatabase.todosTable,
    )..where((el) => el.userId.equals(id))).go();
    await (_appDatabase.delete(
      _appDatabase.userTable,
    )..where((el) => el.id.equals(id))).go();

    return true;
  }
}
