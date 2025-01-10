import 'dart:async';

//TODO: read the project_name via pre-gen hook

import 'package:injectable/injectable.dart';
import 'package:{{project_name}}/features/{{#snakeCase}}{{feature_name}}{{/snakeCase}}/domain/data_sources/{{#snakeCase}}{{feature_name}}{{/snakeCase}}_remote_data_source.dart';

/// {@template {{#snakeCase}}{{feature_name}}{{/snakeCase}}_remote_data_source_impl}
/// An [{{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDataSource] implementation.
/// {@endtemplate}
@LazySingleton(as: {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDataSource)
class {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDataSourceImpl
    implements {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDataSource {
  /// {@macro {{#snakeCase}}{{feature_name}}{{/snakeCase}}_remote_data_source_impl}
  {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDataSourceImpl();

  @override
  Future<Map<String, dynamic>> fetch{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity() async => Future.delayed(
        const Duration(milliseconds: 300),
        () => {
          'id': '1',
        },
      );
}
