

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:your_project_name/core/core.dart';

import '{{#snakeCase}}{{name}}{{/snakeCase}}_params.dart';

@lazySingleton
class {{#pascalCase}}{{name}}UC{{/pascalCase}} implements UseCase<{{type}}, {{#pascalCase}}{{name}}Params{{/pascalCase}}> {

  const {{#pascalCase}}{{name}}UC{{/pascalCase}}();

  Future<Either<Failure, {{type}}>> call({{#pascalCase}}{{name}}Params{{/pascalCase}} params) async {
    //TODO implement
  }
}
