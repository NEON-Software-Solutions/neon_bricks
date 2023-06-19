import 'package:flutter/material.dart';{{#uses_authentication_feature}}
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:{{project_name}}/features/authentication/authentication.dart';{{/uses_authentication_feature}}
import 'package:{{project_name}}/features/user_profile/user_profile.dart';

class UserProfileLoader extends StatelessWidget {
  const UserProfileLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {{^uses_authentication_feature}}final user = User(name: 'test', id: '1');

    return UserProfilePage(user: user);{{/uses_authentication_feature}}
    {{#uses_authentication_feature}}
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) => state.maybeMap(
        orElse: () => Container(),
        authenticated: (authenticatedState) =>
            UserProfilePage(user: authenticatedState.user),
      ),
    );
    {{/uses_authentication_feature}}
  }
}



