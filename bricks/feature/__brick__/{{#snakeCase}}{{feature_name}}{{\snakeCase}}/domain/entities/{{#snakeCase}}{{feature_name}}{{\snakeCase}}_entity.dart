/// {@template {{#snakeCase}}{{feature_name}}{{/snakeCase}}_entity}
/// An abstraction for the {{feature_name}} entity.
/// {@endtemplate}
class {{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity {
  /// {@macro {{#snakeCase}}{{feature_name}}{{/snakeCase}}_entity}
  const {{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity({
    required this.id,
  });

  /// Converts a JSON object into a [{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity] instance.
  factory {{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity.fromJson(Map<String, dynamic> json) =>
      {{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity(
        id: json['id'] as String,
      );

  /// The ID of the {{feature_name}} entity.
  final String id;

  /// Converts this [{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity] instance into a JSON object.
  Map<String, String> toJson() => {
        'id': id,
      };

  /// A human-readable representation to be displayed in logs.
  String get displayString => '{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity(id: $id)';
}
