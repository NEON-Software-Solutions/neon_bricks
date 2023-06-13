import 'package:injectable/injectable.dart';{{#authentication_firebase_auth_feature}}
import 'package:neon_core/neon_core.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:{{project_name}}/features/user_profile/user_profile.dart';
import 'package:{{project_name}}/features/authentication/authentication.dart';{{#firebase_crashlytics_feature}}
import 'package:{{project_name}}/core/core.dart';{{/firebase_crashlytics_feature}}{{/authentication_firebase_auth_feature}}{{^authentication_firebase_auth_feature}}
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:{{project_name}}/app_settings.dart';

part 'authentication_data_source.g.dart';

//TODO: if you do not use retrofit, change this file to fit your needs.
//Do not forget to remove retrofit (and dio) from pubspec.yaml
//if you're using firebase, you might even consider doing all the calls inside
//the auth repository.

@injectable
@RestApi(baseUrl: kHostName) //TODO: change this to be valid
abstract class AuthenticationDatasource {
  //TODO: change these to fit your backend API
  static const kEmailKey = 'email';
  static const kUsernameKey = 'username';
  static const kPasswordKey = 'password';

  static const _loginPath = 'login';
  static const _signUpPath = 'signUp';

  @factoryMethod
  factory AuthenticationDatasource(Dio dio,
      {@Named('baseUrl') String? baseUrl}) = _AuthenticationDatasource;

  @POST("/v{version}/$_loginPath")
  Future<dynamic> login({
    @Body() required Map<String, dynamic> body,
    @Path("version") int version = kApiVersion,
  });

  //TODO: use this logic if you use FormData in the backend

  // @POST("/v{version}/$_loginPath")
  // Future<dynamic> login({
  //   @Part(name: 'foo-bar-image-key', contentType: 'image/jpeg')
  //       required File file,
  //   @Part(name: kEmailKey) required String email,
  //   @Part(name: kPasswordKey) required String password,
  //   @Path("version") int version = kApiVersion,
  // });

  @POST("/v{version}/$_signUpPath")
  Future<dynamic> signUp({
    @Body() required Map<String, dynamic> body,
    @Path("version") int version = kApiVersion,
  });
}
{{/authentication_firebase_auth_feature}}{{#authentication_firebase_auth_feature}}
class MyFirebaseAuthException implements Exception {
  final String message;
  MyFirebaseAuthException(this.message);
}

@injectable
class AuthenticationDatasource {
  final firebase_auth.FirebaseAuth firebaseAuth;

  const AuthenticationDatasource(this.firebaseAuth);

  Future<Either<Failure, User>> signUp(SignUpParams params) async {
    try {
      final userCreds = await firebaseAuth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      if (userCreds.user != null) {
        await userCreds.user!.updateDisplayName(params.username);
        return right(
          User(id: userCreds.user!.uid, name: params.username),
        );
      } else {
        throw MyFirebaseAuthException(
            'Received UserCreds with null user from FirebaseAuth after sign up');
      }
    } catch (e{{#firebase_crashlytics_feature}}, stackTrace{{/firebase_crashlytics_feature}}) {
      String? errorMessage;
      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'emailAlreadyInUse'.tr();
            break;
          case 'invalid-email':
            errorMessage = 'invalidEmail'.tr();
            break;
          case 'operation-not-allowed':
            errorMessage = 'operationNotAllowed'.tr();
            break;
          case 'weak-password':
            errorMessage = 'weakPassword'.tr();
            break;
        }
      } else if (e is MyFirebaseAuthException) {
        errorMessage = e.message;
      }
      //TODO: implement additional error handling{{#firebase_crashlytics_feature}}
      await handleError(error: e, stackTrace: stackTrace);{{/firebase_crashlytics_feature}}
      
      return Left(Failure(errorMessage));
    }
  }

  Future<Either<Failure, User>> login(LoginParams params) async {
    try {
      final userCreds = await firebaseAuth.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      if (userCreds.user != null) {
        String? userName = userCreds.user!.displayName;
        if (userName == null) {
          final currentUser = firebaseAuth.currentUser;
          if (currentUser != null) {
            userName = currentUser.displayName;
          }
        }

        return right(
          User(
            id: userCreds.user!.uid,
            name: userName ?? 'noUserName'.tr(),
          ),
        );
      } else {
        throw (MyFirebaseAuthException(
            'Received UserCreds with null user from FirebaseAuth after login'));
      }
    } catch (e{{#firebase_crashlytics_feature}}, stackTrace{{/firebase_crashlytics_feature}}) {
      String? errorMessage;
      if (e is firebase_auth.FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'invalidEmail'.tr();
            break;
          case 'user-disabled':
            errorMessage = 'userDisabled'.tr();
            break;
          case 'user-not-found':
            errorMessage = 'userNotFound'.tr();
            break;
          case 'wrong-password':
            errorMessage = 'wrongPassword'.tr();
            break;
        }
      } else if (e is MyFirebaseAuthException) {
        errorMessage = e.message;
      }
      //TODO: implement additional error handling{{#firebase_crashlytics_feature}}
      await handleError(error: e, stackTrace: stackTrace);{{/firebase_crashlytics_feature}}

      return Left(Failure(errorMessage));
    }
  }
}
{{/authentication_firebase_auth_feature}}