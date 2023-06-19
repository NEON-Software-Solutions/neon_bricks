import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = context.vars;

  final usesAuthentication = vars['authentication_own_backend_feature'] ||
      vars['authentication_firebase_auth_feature'];

  final mainAppSpecs = _buildMainAppSpecs(
    vars: vars,
    usesAuthentication: usesAuthentication,
  );

  //make sure its EITHER firebase OR own backend
  if (vars['authentication_own_backend_feature'] &&
      vars['authentication_firebase_auth_feature']) {
    throw Exception(
        'Authentication Feature Brick: You can only choose one authentication backend');
  }

  context.vars = {
    ...vars,
    'uses_authentication': usesAuthentication,
    ...mainAppSpecs,
  };
}

Map<String, dynamic> _buildMainAppSpecs({
  required Map<String, dynamic> vars,
  required bool usesAuthentication,
}) {
  final importsFlutterBloc = vars['internet_cubit'] ||
      vars['theme_switching'] ||
      vars['authentication_own_backend_feature'] ||
      vars['authentication_firebase_auth_feature'];

  final importsInjection = vars['internet_cubit'] ||
      vars['theme_switching'] ||
      vars['authentication_own_backend_feature'] ||
      vars['authentication_firebase_auth_feature'];

  final mainAppLoaderImportsFlutterBloc = vars['internet_cubit'] ||
      vars['theme_switching'] ||
      vars['authentication_own_backend_feature'] ||
      vars['authentication_firebase_auth_feature'];

  final mainAppLoaderImportsCore = vars['internet_cubit'];

  final initializesFirebaseApp = vars['authentication_firebase_auth_feature'] ||
      vars['firebase_localization_loader_feature'] ||
      vars['firebase_crashlytics_feature'] ||
      vars['share_feature'];

  final rendersColumnInMainApp =
      usesAuthentication || vars['theme_switching'] || vars['share_feature'];

  return {
    'imports_flutter_bloc': importsFlutterBloc,
    'imports_injection': importsInjection,
    'initializes_firebase_app': initializesFirebaseApp,
    'main_app_loader_imports_flutter_bloc': mainAppLoaderImportsFlutterBloc,
    'main_app_loader_imports_core': mainAppLoaderImportsCore,
    'main_app_loader_renders_column': rendersColumnInMainApp,
  };
}
