{{> app_imports.dart }}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return {{#internet_cubit}}BlocProvider(create: (context) => getIt<InternetConnectionCubit>()..initialize(),child:{{/internet_cubit}}
    {{#theme_switching}}BlocProvider(create: (context) => getIt<ThemeCubit>(),child:BlocBuilder<ThemeCubit, ThemeData>(builder: (context, currentTheme) => {{/theme_switching}}
    {{#uses_authentication}}
    BlocProvider(
          create: (context) => getIt<AuthenticationBloc>()
            ..add(const AuthenticationEvent.initialize()),
            child:{{/uses_authentication}}
    {{> material_app.dart }}{{#internet_cubit}},){{/internet_cubit}}{{#uses_authentication}},){{/uses_authentication}}{{#theme_switching}},),){{/theme_switching}};
  }
}
