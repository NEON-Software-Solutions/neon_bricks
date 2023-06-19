import 'package:flutter/material.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';{{#user_feature}}
import 'package:flutter/cupertino.dart';{{/user_feature}}

{{#internet_cubit}}import 'package:neon_core/neon_core.dart';{{/internet_cubit}}
import 'package:easy_localization/easy_localization.dart';{{#main_app_loader_imports_flutter_bloc}}
import 'package:flutter_bloc/flutter_bloc.dart';{{/main_app_loader_imports_flutter_bloc}}
{{#share_feature}}
import 'package:{{project_name}}/features/share/share.dart';
import 'package:{{project_name}}/injection.dart';{{/share_feature}}{{#theme_switching}}

import 'package:{{project_name}}/features/theme_switching/theme_switching.dart';{{/theme_switching}}{{#main_app_loader_imports_core}}
import 'package:{{project_name}}/core/core.dart';{{/main_app_loader_imports_core}}{{#uses_authentication}}
import 'package:{{project_name}}/features/authentication/authentication.dart';{{/uses_authentication}}

{{#uses_authentication}}{{#toast_service}}BuildContext? cachedContext;{{/toast_service}}{{/uses_authentication}}

class MainAppLoader extends StatelessWidget {
  const MainAppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {{#uses_authentication}}final user = context.read<AuthenticationBloc>().authenticatedUser;{{/uses_authentication}}

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          'homePageTitle'.tr(),
          maxLines: 1,
        ),{{#user_feature}}
        actions: [
          const IconButton(
            onPressed: null,
            icon: Icon(CupertinoIcons.home),
          ),
          IconButton(
            onPressed: () => context.router.navigate(const UserProfileRoute()),
            icon: const Icon(CupertinoIcons.person),
          ),
        ],{{/user_feature}}
      ),
      body: Center(
        child: {{#internet_cubit}}BlocBuilder<InternetConnectionCubit, InternetConnectionState>(
          builder: (context, connectionState) => connectionState.maybeMap(
            orElse: () => AutoSizeText(
              'noInternetConnection'.tr(),
              style: kTextBodyLarge,
            ),
            connected: (_) =>{{/internet_cubit}} 
            {{#main_app_loader_renders_column}}Column(mainAxisAlignment: MainAxisAlignment.center,children: [{{/main_app_loader_renders_column}}
        Text('youAreLoggedIn'.tr(namedArgs: {'userName':{{#uses_authentication}}user!.name{{/uses_authentication}}{{^uses_authentication}}'testUser'{{/uses_authentication}}
        })),{{#theme_switching}}
        BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, state) => TextButton(
                onPressed: context.read<ThemeCubit>().switchTheme,
                child: Text(
                  state.brightness == Brightness.dark
                      ? 'switchToLightTheme'.tr()
                      : 'switchToDarkTheme'.tr(),
                ),
              ),
            ),
          {{/theme_switching}}
        {{#uses_authentication}}
        TextButton(
                  onPressed: () {
                    context.router.popUntilRoot();
                    context
                        .read<AuthenticationBloc>()
                        .add(const AuthenticationEvent.logout());
                  },
                  child: const Text('logout').tr(),
                ),
        {{/uses_authentication}}{{#share_feature}}
         ActionButton(
            title: 'Share',
            onPressed: () => getIt<ShareService>()
                .shareAppContent(context, contentId: 'some-content-id'),
          ),{{/share_feature}}
        {{#main_app_loader_renders_column}}],),{{/main_app_loader_renders_column}}
        {{#internet_cubit}}),),{{/internet_cubit}}
      ),
    );
  }
}
