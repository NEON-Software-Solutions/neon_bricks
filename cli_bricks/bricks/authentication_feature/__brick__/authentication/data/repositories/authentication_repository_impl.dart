import 'package:candy_core/candy_core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:{{project_name}}/features/authentication/data/data_source/authentication_data_source.dart';
import 'package:{{project_name}}/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:{{project_name}}/features/authentication/domain/use_cases/params/params.dart';
import 'package:{{project_name}}/features/user_profile/domain/entities/user.dart';{{#firebase_crashlytics_feature}}
import 'package:{{project_name}}/core/core.dart';{{/firebase_crashlytics_feature}}

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationDatasource datasource;
  const AuthenticationRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, User>> login(LoginParams params) async {
    {{^authentication_firebase_auth_feature}}
    // TODO: implement loginLocally.
    // f.ex. like this:

    // try {
    //   final _body = {
    //     AuthenticationDatasource.kEmailKey: params.email,
    //     AuthenticationDatasource.kPasswordKey: params.password,
    //   };

    //   final res = await datasource.login(body: _body);
    //   if (res != null) {
    //     // do success stuff
    //     try {
    //       final user = User.fromJson(res);
    //       return right(user);
    //     } catch (e{{#firebase_crashlytics_feature}}, stackTrace{{/firebase_crashlytics_feature}}) {
    //       // do parsing failure stuff{{#firebase_crashlytics_feature}}
    //       await handleError(error: e, stackTrace: stackTrace);{{/firebase_crashlytics_feature}} 
    //       return const Left(JsonParsingFailure());
    //     }
    //   } else {
    //     // do server failure stuff{{#firebase_crashlytics_feature}}
    //     //TODO: define own error you can throw here
    //     final serverError = Exception('Server error'); 
    //     await handleError(error: serverError);{{/firebase_crashlytics_feature}}
    //     return const Left(ServerFailure());
    //   }
    // } catch (error{{#firebase_crashlytics_feature}}, stackTrace{{/firebase_crashlytics_feature}}) {
    //   // do error handling stuff{{#firebase_crashlytics_feature}}
    //   await handleError(error: error, stackTrace: stackTrace);{{/firebase_crashlytics_feature}}
    // }

    return right(User(name: 'test', id: '1'));
    {{/authentication_firebase_auth_feature}}{{#authentication_firebase_auth_feature}}
     try {
      return await datasource.login(params);
    } catch (error{{#firebase_crashlytics_feature}}, stackTrace{{/firebase_crashlytics_feature}}) {
      // do error handling stuff{{#firebase_crashlytics_feature}}
      await handleError(error: error, stackTrace: stackTrace);{{/firebase_crashlytics_feature}}
      return const Left(Failure());
    }{{/authentication_firebase_auth_feature}}
  }

  @override
  Future<Either<Failure, User>> signUp(SignUpParams params) async {
    {{^authentication_firebase_auth_feature}}
    // TODO: implement signUp
    // f.ex. like this:

    // try {
    //   final _body = {
    //     AuthenticationDatasource.kEmailKey: params.email,
    //     AuthenticationDatasource.kPasswordKey: params.password,
    //     AuthenticationDatasource.kUsernameKey: params.username,
    //   };

    //   final res = await datasource.signUp(body: _body);
    //   if (res != null) {
    //     // do success stuff
    //     return right(User(name: params.username, id: '1'));
    //   } else {
    //     // do server failure stuff{{#firebase_crashlytics_feature}}
    //     //TODO: define own error you can throw here
    //     final serverError = Exception('Server error'); 
    //     await handleError(error: serverError);{{/firebase_crashlytics_feature}}
    //     return const Left(ServerFailure());
    //   }
    // } catch (error{{#firebase_crashlytics_feature}}, stackTrace{{/firebase_crashlytics_feature}}) {
    //   // do error handling stuff{{#firebase_crashlytics_feature}}
    //   await handleError(error: error, stackTrace: stackTrace);{{/firebase_crashlytics_feature}}
    // }

    return right(User(name: params.username, id: '1'));
    {{/authentication_firebase_auth_feature}}{{#authentication_firebase_auth_feature}}
    try {
      return await datasource.signUp(params);
    } catch (error{{#firebase_crashlytics_feature}}, stackTrace{{/firebase_crashlytics_feature}}) {
      // do error handling stuff{{#firebase_crashlytics_feature}}
      await handleError(error: error, stackTrace: stackTrace);{{/firebase_crashlytics_feature}}
      return const Left(Failure());
    }
    {{/authentication_firebase_auth_feature}}
  }
}
