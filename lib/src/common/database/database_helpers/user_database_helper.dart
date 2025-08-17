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
    final userTableData = UserTableCompanion(
      name: Value(name),
      email: Value(email),
      surname: Value(surname),
    );

    final userData = await _appDatabase.into(_appDatabase.userTable).insertReturning(userTableData);

    return UserModel(
      id: userData.id,
      name: userData.name,
      email: userData.email,
      surname: userData.surname,
    );
  }

  Future<bool> deleteUse(int id) async {
    await (_appDatabase.delete(_appDatabase.userTable)..where((el) => el.id.equals(id))).go();

    return true;
  }
}
