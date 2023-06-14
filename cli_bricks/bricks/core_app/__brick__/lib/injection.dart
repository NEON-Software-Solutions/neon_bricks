import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: false)
void configureInjection(String environment) =>
    getIt.init(environment: environment);

abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}
