import 'package:neon_core/neon_core.dart';
import 'package:dartz/dartz.dart';

import 'package:{{project_name}}/features/authentication/authentication.dart';
import 'package:{{project_name}}/features/user_profile/domain/entities/user.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, User>> login(LoginParams params);
  Future<Either<Failure, User>> signUp(SignUpParams params);
}
