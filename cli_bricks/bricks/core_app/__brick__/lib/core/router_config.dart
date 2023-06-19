import 'package:go_router/go_router.dart';
import 'package:{{project_name}}/core/core.dart';{{#uses_authentication}}
import 'package:{{project_name}}/features/user_profile/user_profile.dart';{{/uses_authentication}}

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainAppLoader(),
    ),{{#uses_authentication}}
    GoRoute(
      path: '/user-profile',
      builder: (context, state) => const UserProfileLoader(),
    ),{{/uses_authentication}}
  ],
);
