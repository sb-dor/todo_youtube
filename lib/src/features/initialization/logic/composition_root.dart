import 'package:logger/logger.dart';
import 'package:todo_youtube/src/common/database/app_database.dart';
import 'package:todo_youtube/src/common/database/database_helpers/todos_database_helper.dart';
import 'package:todo_youtube/src/common/database/database_helpers/user_database_helper.dart';
import 'package:todo_youtube/src/common/internet_connection_checker.dart';
import 'package:todo_youtube/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_datasource.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_repository.dart';
import 'package:todo_youtube/src/features/initialization/model/dependency_container.dart';
import 'package:todo_youtube/src/features/todos/data/todos_datasource.dart';
import 'package:todo_youtube/src/features/todos/data/todos_repository.dart';

// Future<CompositionRoot> compositionRoot() async {
//
// }

Future<DependencyContainer> createDependencies({required Logger logger}) async {
  final appDatabase = AppDatabase.custom();

  final internetConnectionChecker = InternetConnectionChecker();

  final todosRepository = createTodosRepository(
    appDatabase: appDatabase,
    logger: logger,
    internetConnectionChecker: internetConnectionChecker,
  );

  final authenticationBlocV = authenticationBloc(
    appDatabase: appDatabase,
    logger: logger,
    internetConnectionChecker: internetConnectionChecker,
  );

  return DependencyContainer(
    logger: logger,
    appDatabase: appDatabase,
    todosRepository: todosRepository,
    authenticationBloc: authenticationBlocV,
  );
}

ITodosRepository createTodosRepository({
  required AppDatabase appDatabase,
  required Logger logger,
  required InternetConnectionChecker internetConnectionChecker,
}) {
  final todosDatabaseHelper = TodosDatabaseHelper(
    appDatabase: appDatabase,
    logger: logger,
  );
  final todosLocalDatasource = TodosDatasourceLocalImpl(
    todosDatabaseHelper: todosDatabaseHelper,
  );
  final todosRemoteDatasource = TodosDatasourceRemoteImpl();
  return TodosRepositoryImpl(
    todoRemoteDatasource: todosRemoteDatasource,
    todoLocalDatasource: todosLocalDatasource,
    internetConnectionChecker: internetConnectionChecker,
  );
}

AuthenticationBloc authenticationBloc({
  required AppDatabase appDatabase,
  required Logger logger,
  required InternetConnectionChecker internetConnectionChecker,
}) {
  final userDatabaseHelper = UserDatabaseHelper(appDatabase);
  final IAuthenticationDatasource authenticationRemoteDatasource =
      AuthenticationRemoteDatasource();
  final IAuthenticationDatasource authenticationLocalDatasource =
      AuthenticationLocalDatasource(userDatabaseHelper: userDatabaseHelper);

  final IAuthenticationRepository repository = AuthenticationRepositoryImpl(
    authenticationRemoteDatasource: authenticationRemoteDatasource,
    authenticationLocalDatasource: authenticationLocalDatasource,
    internetConnectionChecker: internetConnectionChecker,
  );

  return AuthenticationBloc(
    iAuthenticationRepository: repository,
    logger: logger,
  );
}

Logger createAppLogger({required LogFilter logFilter}) {
  return Logger(
    filter: logFilter,
    printer: PrettyPrinter(
      methodCount: 2,
      // Number of method calls to be displayed
      errorMethodCount: 8,
      // Number of method calls if stacktrace is provided
      lineLength: 120,
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      // Should each log print contain a timestamp
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    output: ConsoleOutput(),
  );
}

final class NoOpLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false;
  }
}

// class CompositionRoot {
//   CompositionRoot(this.dependencyContainer);
//
//   final DependencyContainer dependencyContainer;
// }
