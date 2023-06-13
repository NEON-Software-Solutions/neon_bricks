import 'package:candy_core/candy_core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:{{project_name}}/features/user_profile/domain/entities/user.dart';
import 'package:{{project_name}}/features/authentication/domain/repositories/authentication_repository.dart';

import 'params/sign_up_params.dart';

@lazySingleton
class SignUpUC implements UseCase<User, SignUpParams> {
  final AuthenticationRepository authenticationRepository;

  SignUpUC(this.authenticationRepository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    return await authenticationRepository.signUp(params);
  }
}
