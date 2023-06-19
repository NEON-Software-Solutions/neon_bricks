import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as path;

Future<void> run(HookContext context) async {
  final vars = context.vars;
  final projectRootDir = Directory(path.join('.', vars['project_name']));
  final projectLibDir = Directory(path.join(projectRootDir.path, 'lib'));

  // if none of there features are used, injectable_module.dart will be empty
  if (!vars['internet_cubit'] &&
      !vars['authentication_own_backend_feature'] &&
      !vars['authentication_firebase_auth_feature'] &&
      !vars['firebase_localization_loader_feature'] &&
      !vars['firebase_crashlytics_feature']) {
    await _delete(
      dir: Directory(
        path.join(projectLibDir.path),
      ),
      fileOrDirName: 'injectable_module.dart',
    );
  }

  // if the features are used in that constellation, app_settings.dart will be empty
  if (vars['theme_switching'] &&
      !vars['authentication_own_backend_feature'] &&
      !vars['share_feature']) {
    await _delete(
      dir: Directory(
        path.join(projectLibDir.path),
      ),
      fileOrDirName: 'app_settings.dart',
    );
  }

  if (!vars['navigator_service'] && !vars['toast_service']) {
    await _delete(
      dir: Directory(
        path.join(projectLibDir.path, 'core'),
      ),
      fileOrDirName: 'services',
    );
  }

  if (vars['firebase_localization_loader_feature']) {
    // delete arb files and l10n.yaml
    await _delete(
      dir: projectLibDir,
      fileOrDirName: 'l10n',
    );
    await _delete(
      dir: projectRootDir,
      fileOrDirName: 'l10n.yaml',
    );
  } else {
    // delete translation files
    await _delete(
      dir: Directory(
        path.join(projectRootDir.path, 'assets'),
      ),
      fileOrDirName: 'translations',
    );
  }

  // the critical values for the multi bloc to be used in app.dart are
  // theme_switching, internet_cubit and authentication_own_backend_feature.
  // thus, we count whether more than one of those is set to true.

  final multiBlocProviderInfluencersSetToTrue = List<bool>.from(
    [
      vars['theme_switching'] as bool,
      vars['internet_cubit'] as bool,
      vars['authentication_own_backend_feature'] as bool,
    ].where((value) => value),
  );

  final needsMultiBlocProvider =
      multiBlocProviderInfluencersSetToTrue.length > 1;

  if (needsMultiBlocProvider) {
    await _delete(
      dir: projectLibDir,
      fileOrDirName: 'app_with_provider.dart',
    );
    await _renameFileToMainAppFile(
      dir: projectLibDir,
      oldFileName: 'app_with_multi_provider.dart',
    );
    return;
  }

  await _delete(
    dir: projectLibDir,
    fileOrDirName: 'app_with_multi_provider.dart',
  );
  await _renameFileToMainAppFile(
    dir: projectLibDir,
    oldFileName: 'app_with_provider.dart',
  );
}

Future<void> _delete({
  required Directory dir,
  required String fileOrDirName,
}) async {
  final file = File(path.join(dir.path, fileOrDirName));

  await file.delete(recursive: true);
}

Future<void> _renameFileToMainAppFile({
  required Directory dir,
  required String oldFileName,
}) async {
  final file = File(path.join(dir.path, oldFileName));

  await file.rename(
    path.join(dir.path, 'app.dart'),
  );
}
