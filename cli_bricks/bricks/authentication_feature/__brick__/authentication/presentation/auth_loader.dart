import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';

import 'package:{{project_name}}/features/authentication/authentication.dart';
import 'package:{{project_name}}/features/authentication/presentation/auth_page.dart';
import 'package:{{project_name}}/injection.dart';

@RoutePage()
class AuthLoader extends StatelessWidget {
  const AuthLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<LoginBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<SignUpBloc>(),
        ),
      ],
      child: const AuthPage(),
    );
  }
}
