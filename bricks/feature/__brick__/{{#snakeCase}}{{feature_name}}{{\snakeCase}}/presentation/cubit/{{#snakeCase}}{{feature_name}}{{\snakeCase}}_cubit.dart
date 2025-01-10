import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:neon_core/neon_core.dart';
import 'package:{{project_name}}/features/{{#snakeCase}}{{feature_name}}{{/snakeCase}}/domain/domain_barrel.dart';

/// {@template {{#snakeCase}}{{feature_name}}{{/snakeCase}}_state}
/// The state the [{{#pascalCase}}{{feature_name}}{{/pascalCase}}Cubit] emits.
/// {@endtemplate}
typedef {{#pascalCase}}{{feature_name}}{{/pascalCase}}State
    = OperationState<{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity, CustomException>;

/// {@template {{#snakeCase}}{{feature_name}}{{/snakeCase}}_cubit}
/// Manages the {{feature_name}} feature.
/// {@endtemplate}
@injectable
class {{#pascalCase}}{{feature_name}}{{/pascalCase}}Cubit extends Cubit<{{#pascalCase}}{{feature_name}}{{/pascalCase}}State> {
  /// {@macro {{#snakeCase}}{{feature_name}}{{/snakeCase}}_cubit}
  {{#pascalCase}}{{feature_name}}{{/pascalCase}}Cubit(this._repository)
      : super(const OperationState.initial());

  final {{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository _repository;

  /// Fetches the {{feature_name}} entity.
  Future<void> fetch{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity() async {
    safeEmit(const OperationState.loading());
    final res = await _repository.fetch{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity();

    safeEmit(
      switch (res) {
        Fehler(exception: final e) => OperationState.failure(e),
        Wert(value: final {{#camelCase}}{{feature_name}}{{/camelCase}}Entity) =>
          OperationState.success({{#camelCase}}{{feature_name}}{{/camelCase}}Entity)
      },
    );
  }
}
