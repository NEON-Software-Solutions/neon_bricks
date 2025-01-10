/// {@template {{#snakeCase}}{{feature_name}}{{/snakeCase}}_remote_data_source}
/// An interface for the {{feature_name}} remote data source.
/// {@endtemplate}
abstract class {{#pascalCase}}{{feature_name}}{{/pascalCase}}RemoteDataSource {
  /// Tries to fetch the {{feature_name}} CRUD entity.
  Future<Map<String, dynamic>> fetch{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity();
}
