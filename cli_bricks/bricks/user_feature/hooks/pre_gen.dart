import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = context.vars;
  bool usesAuth = false;
  if (vars['authentication_own_backend_feature'] ||
      vars['authentication_firebase_auth_feature']) {
    usesAuth = true;
  }

  context.vars = {
    ...vars,
    'uses_authentication_feature': usesAuth,
  };
}
