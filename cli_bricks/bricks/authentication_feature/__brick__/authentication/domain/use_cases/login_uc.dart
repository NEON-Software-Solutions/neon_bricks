import 'package:neon_core/neon_core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:{{project_name}}/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:{{project_name}}/features/user_profile/user_profile.dart';

import 'params/login_params.dart';

@lazySingleton
class LoginUC implements UseCase<User, LoginParams> {
  final AuthenticationRepository authenticationRepository;

  LoginUC(this.authenticationRepository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await authenticationRepository.login(params);
  }
}
