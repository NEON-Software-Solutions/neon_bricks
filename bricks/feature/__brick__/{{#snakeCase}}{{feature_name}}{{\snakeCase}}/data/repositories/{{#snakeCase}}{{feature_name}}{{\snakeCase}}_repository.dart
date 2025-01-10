import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:neon_core/neon_core.dart';
import 'package:neon_flutter_services/neon_flutter_services.dart';
import 'package:{{project_name}}/core/services/custom_error_handling_service.dart';
import 'package:{{project_name}}/features/{{#snakeCase}}{{feature_name}}{{/snakeCase}}/domain/data_sources/data_sources_barrel.dart';
import 'package:{{project_name}}/features/{{#snakeCase}}{{feature_name}}{{/snakeCase}}/domain/entities/entities_barrel.dart';
import 'package:{{project_name}}/features/{{#snakeCase}}{{feature_name}}{{/snakeCase}}/domain/repositories/{{#snakeCase}}{{feature_name}}{{/snakeCase}}_repository.dart';

/// {@template {{#snakeCase}}{{feature_name}}{{/snakeCase}}_repository_impl}
/// The implementation of the [{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository].
/// {@endtemplate}
@LazySingleton(as: {{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository)
class {{#pascalCase}}{{feature_name}}{{/pascalCase}}RepositoryImpl implements {{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository {
  /// {@macro {{#snakeCase}}{{feature_name}}{{/snakeCase}}_repository_impl}
  {{#pascalCase}}{{feature_name}}{{/pascalCase}}RepositoryImpl(
    this.{{#camelCase}}{{feature_name}}{{/camelCase}}RemoteDataSource,
    this._log,
    this._errorHandlingService,
  );

  /// The remote data source that handles all {{feature_name}} CRUD requests.
  final {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDataSource {{#camelCase}}{{feature_name}}{{/camelCase}}RemoteDataSource;

  final LoggingService _log;
  final CustomErrorHandlingService _errorHandlingService;

  @override
  Future<Vielleicht<{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity>> fetch{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity() async {
    late Map<String, dynamic> {{#camelCase}}{{feature_name}}{{/camelCase}}EntityData;
    try {
      {{#camelCase}}{{feature_name}}{{/camelCase}}EntityData =
          await {{#camelCase}}{{feature_name}}{{/camelCase}}RemoteDataSource.fetch{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity();
    } catch (e) {
      _log.e('Error while trying to fetch the {{feature_name}} entity data: $e');
      final exception =
          _errorHandlingService.getCustomExceptionForDynamicError(e);
      return Fehler(exception: exception);
    }
    try {
      final {{#camelCase}}{{feature_name}}{{/camelCase}}Entity =
          {{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity.fromJson({{#camelCase}}{{feature_name}}{{/camelCase}}EntityData);
      return Wert({{#camelCase}}{{feature_name}}{{/camelCase}}Entity);
    } catch (e) {
      _log.e('Error while trying to parse the {{feature_name}} entity: $e');
      final exception =
          _errorHandlingService.getCustomExceptionForDynamicError(e);
      return Fehler(exception: exception);
    }
  }
}
