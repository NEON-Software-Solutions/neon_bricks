import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name}}/core/injection/injection.dart';
import 'package:{{project_name}}/features/{{#snakeCase}}{{feature_name}}{{/snakeCase}}/presentation/presentation_barrel.dart';

part 'pages/{{#snakeCase}}{{feature_name}}{{/snakeCase}}_page.dart';

/// {@template {{#snakeCase}}{{feature_name}}{{/snakeCase}}_loader}
/// The loader for the {{feature_name}} screen. Provides all the needed
/// blocs.
/// {@endtemplate}
class {{#pascalCase}}{{feature_name}}{{/pascalCase}}Loader extends StatelessWidget {
  /// {@macro {{#snakeCase}}{{feature_name}}{{/snakeCase}}_loader}
  const {{#pascalCase}}{{feature_name}}{{/pascalCase}}Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<{{#pascalCase}}{{feature_name}}{{/pascalCase}}Cubit>()..fetch{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity(),
      child: const _{{#pascalCase}}{{feature_name}}{{/pascalCase}}Page(),
    );
  }
}
