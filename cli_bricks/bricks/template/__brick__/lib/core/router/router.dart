import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:{{project_name}}/app_loader.dart';
import 'package:{{project_name}}/core/core.dart';{{#user_feature}}
import 'package:{{project_name}}/features/user_profile/user_profile.dart';{{/user_feature}}{{#uses_authentication}}
import 'package:{{project_name}}/features/authentication/presentation/auth_loader.dart';{{/uses_authentication}}

part 'router.gr.dart';

//TODO: set this up

@AutoRouterConfig(
  replaceInRouteName: 'Loader|Page,Route',
  routes: <AutoRoute>[
    AutoRoute<dynamic>(
      page: AppLoader,
      initial: true,
    ),
    AutoRoute<dynamic>(
      page: MainAppLoader,
    ),
    {{#user_feature}}
    AutoRoute<dynamic>(
      page: UserProfileLoader,
    ),{{/user_feature}}
    {{#uses_authentication}}
    AutoRoute<dynamic>(
      page: AuthLoader,
    ),{{/uses_authentication}}
  ],
)
class AppRouter extends _$AppRouter {}
