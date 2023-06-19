import 'package:go_router/go_router.dart';
import 'package:{{project_name}}/core/core.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainAppLoader(),
    ),
  ],
);
