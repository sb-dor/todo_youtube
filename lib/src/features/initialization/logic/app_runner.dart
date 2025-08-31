import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo_youtube/src/common/bloc_observer.dart';
import 'package:todo_youtube/src/features/initialization/widget/failed_app_widget.dart';
import 'package:todo_youtube/src/features/initialization/widget/material_context.dart';
import 'composition_root.dart';

class AppRunner {
  Future<void> run() async {
    final logger = createAppLogger(
      logFilter: kReleaseMode ? NoOpLogFilter() : DevelopmentFilter(),
    );
    //
    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        Bloc.transformer = sequential();
        Bloc.observer = BlocObserverManager(logger: logger);

        FlutterError.onError = (errorDetails) {
          logger.log(Level.error, errorDetails);
          // FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          logger.log(Level.error, "error $error | stacktrace: $stack");
          // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

          return true;
        };

        try {
          final dependencies = await createDependencies(logger: logger);

          runApp(MaterialContext(dependencyContainer: dependencies));
        } catch (error, stackTrace) {
          runApp(FailedAppWidget());
          Error.throwWithStackTrace(error, stackTrace);
        }
      },
      (error, stackTrace) {
        logger.log(
          Level.error,
          "Error zone:",
          error: error,
          stackTrace: stackTrace,
        );
        //
        if (kReleaseMode) {
          // FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
        }
      },
    );
  }
}
