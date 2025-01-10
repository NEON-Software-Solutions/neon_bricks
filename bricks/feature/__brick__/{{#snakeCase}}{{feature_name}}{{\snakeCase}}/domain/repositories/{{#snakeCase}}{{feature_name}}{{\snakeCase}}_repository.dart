import 'package:neon_core/neon_core.dart';
import 'package:{{project_name}}/features/{{#snakeCase}}{{feature_name}}{{/snakeCase}}/domain/entities/{{#snakeCase}}{{feature_name}}{{/snakeCase}}_entity.dart';

/// {@template {{#snakeCase}}{{feature_name}}{{/snakeCase}}_repository}
/// The repository that handles the {{feature_name}} feature.
/// {@endtemplate}
abstract class {{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository {
  /// Tries to fetch a {{feature_name}} entity. Returns either a [Wert] if
  /// successful or a [Fehler] if not.
  Future<Vielleicht<{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity>> fetch{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity();
}
