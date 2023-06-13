import 'package:flutter/cupertino.dart';{{#uses_authentication}}
import 'package:flutter_bloc/flutter_bloc.dart';{{#share_feature}}
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';{{/share_feature}}

import 'package:{{project_name}}/features/authentication/authentication.dart';{{/uses_authentication}}
import 'package:{{project_name}}/core/core.dart';{{#share_feature}}
import 'package:{{project_name}}/features/share/domain/dynamic_links_service.dart';
import 'package:{{project_name}}/injection.dart';{{/share_feature}}

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {{#uses_authentication}}{{#share_feature}}return BlocConsumer<AuthenticationBloc, AuthenticationState>(
    listener: (context, state) {
        final dynamicLinkService = getIt<DynamicLinkService>();
        PendingDynamicLinkData? cachedDynamicLink;
        state.maybeMap(
          authenticated: (state) {
            dynamicLinkService.getAndHandlePendingDynamicLink(
              context,
              isLoggedIn: true,
              cachedUri: cachedDynamicLink,
            );
            cachedDynamicLink = null;
          },
          orElse: () async {
            final link = await dynamicLinkService.getAndHandlePendingDynamicLink(
              context,
              isLoggedIn: false,
            );
            if (link != null) {
              cachedDynamicLink = link;
            }
          },
        );
      },
      builder: (context, state) => state.maybeMap(
        orElse: () => const AuthLoader(),
        authenticated: (_) => const MainAppLoader(),
      ),
    );{{/share_feature}}{{^share_feature}}return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) => state.maybeMap(
        orElse: () => const AuthLoader(),
        authenticated: (_) => const MainAppLoader(),
      ),
    );{{/share_feature}}{{/uses_authentication}}{{^uses_authentication}}{{#share_feature}}
    final dynamicLinkService = getIt<DynamicLinkService>();

    dynamicLinkService.getAndHandlePendingDynamicLink(
      context,
      isLoggedIn: true,
    );{{/share_feature}}
    return const MainAppLoader();{{/uses_authentication}}
  }
}


