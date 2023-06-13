import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:{{project_name}}/injection.dart';

Future<void> handleError({
  required dynamic error,
  StackTrace? stackTrace,
  String? reason,
  Iterable<Object> information = const [],
}) async {
  return await getIt<FirebaseCrashlytics>().recordError(
    error,
    stackTrace,
    reason: reason,
    information: information,
  );
}
