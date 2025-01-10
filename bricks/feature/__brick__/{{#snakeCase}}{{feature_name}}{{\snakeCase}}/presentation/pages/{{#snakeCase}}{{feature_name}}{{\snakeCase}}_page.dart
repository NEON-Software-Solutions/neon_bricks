part of '../{{#snakeCase}}{{feature_name}}{{/snakeCase}}_loader.dart';

/// {@template {{#snakeCase}}{{feature_name}}{{/snakeCase}}_page}
/// The {{feature_name}} page.
/// {@endtemplate}
class _{{#pascalCase}}{{feature_name}}{{/pascalCase}}Page extends StatelessWidget {
  /// {@macro {{#snakeCase}}{{feature_name}}{{/snakeCase}}_page}
  const _{{#pascalCase}}{{feature_name}}{{/pascalCase}}Page();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<{{#pascalCase}}{{feature_name}}{{/pascalCase}}Cubit, {{#pascalCase}}{{feature_name}}{{/pascalCase}}State>(
        builder: (context, state) => state.maybeWhen(
          success: (entity) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Got the entity: ${entity.id}'),
              TextButton(
                onPressed: context
                    .read<{{#pascalCase}}{{feature_name}}{{/pascalCase}}Cubit>()
                    .fetch{{#pascalCase}}{{feature_name}}{{/pascalCase}}Entity,
                child: const Text('Fetch again'),
              ),
            ],
          ),
          failure: (_) => const Center(
            child: Text('Failed to fetch {{feature_name}} entity'),
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
