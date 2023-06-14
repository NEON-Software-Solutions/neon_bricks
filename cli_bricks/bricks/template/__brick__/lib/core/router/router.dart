import 'package:auto_route/auto_route.dart';

import 'package:{{project_name}}/app_loader.dart';
import 'package:{{project_name}}/core/core.dart';{{#user_feature}}
import 'package:{{project_name}}/features/user_profile/user_profile.dart';{{/user_feature}}{{#uses_authentication}}
import 'package:{{project_name}}/features/authentication/presentation/auth_loader.dart';{{/uses_authentication}}

part 'router.gr.dart';

//TODO: set this up

@AutoRouterConfig(
  replaceInRouteName: 'Loader|Page,Route',
)
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  // TODO: implement routes
  List<AutoRoute> get routes => [
        AutoRoute(page: AppRoute.page, initial: true),
        AutoRoute(
          page: MainAppRoute.page,
        ),
        {{#user_feature}}
        AutoRoute(
          page: UserProfileRoute.page,
        ),{{/user_feature}}
        {{#uses_authentication}}
        AutoRoute(
          page: AuthRoute.page,
        ),{{/uses_authentication}}
      ];
}
