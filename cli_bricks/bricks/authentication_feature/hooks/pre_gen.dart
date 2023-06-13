import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = context.vars;
  //make sure its EITHER firebase OR own backend
  if (vars['authentication_own_backend_feature'] &&
      vars['authentication_firebase_auth_feature']) {
    throw Exception(
        'Authentication Feature Brick: You can only choose one authentication backend');
  }
}
