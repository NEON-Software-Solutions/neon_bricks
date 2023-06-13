{{> app_imports.dart }}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        {{#internet_cubit}}BlocProvider(create: (context) => getIt<InternetConnectionCubit>()..initialize(),),{{/internet_cubit}}
        {{#theme_switching}}BlocProvider(create: (context) => getIt<ThemeCubit>(),),{{/theme_switching}}
        {{#uses_authentication}}BlocProvider(
          create: (context) => getIt<AuthenticationBloc>()
            ..add(const AuthenticationEvent.initialize()),
        ),{{/uses_authentication}}
      ],
      child: {{#theme_switching}}BlocBuilder<ThemeCubit, ThemeData>(builder: (context, currentTheme) =>{{/theme_switching}}
   {{> material_app.dart }},){{#theme_switching}},){{/theme_switching}};
  }
}
