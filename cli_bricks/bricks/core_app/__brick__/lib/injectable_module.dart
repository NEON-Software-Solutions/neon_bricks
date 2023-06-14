import 'package:injectable/injectable.dart';{{#internet_cubit}}
import 'package:neon_core/neon_core.dart';{{/internet_cubit}}{{#authentication_firebase_auth_feature}}
import 'package:firebase_auth/firebase_auth.dart';{{/authentication_firebase_auth_feature}}{{#firebase_localization_loader_feature}}
import 'package:firebase_remote_config/firebase_remote_config.dart';{{/firebase_localization_loader_feature}}{{#firebase_crashlytics_feature}}
import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/firebase_crashlytics_feature}}{{#authentication_own_backend_feature}}
import 'package:dio/dio.dart';

import 'package:{{project_name}}/app_settings.dart';{{/authentication_own_backend_feature}}{{#share_feature}}{{^internet_cubit}}
import 'package:neon_core/neon_core.dart';{{/internet_cubit}}
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';{{/share_feature}}

@module
abstract class RegisterModule {
   {{#authentication_own_backend_feature}}@singleton
  Dio get dioInstance => Dio();

  @Named('baseUrl')
  String get baseUrl => kHostName;
  {{/authentication_own_backend_feature}}{{#authentication_firebase_auth_feature}}
  @singleton
  FirebaseAuth get firebaseAuthInstance => FirebaseAuth.instance;{{/authentication_firebase_auth_feature}}{{#firebase_localization_loader_feature}}
  
  @singleton
  FirebaseRemoteConfig get firebaseRemoteConfigInstance =>
      FirebaseRemoteConfig.instance;
  {{/firebase_localization_loader_feature}}{{#firebase_crashlytics_feature}}
  
  @singleton
  FirebaseCrashlytics get firebaseCrashlyticsInstance =>
      FirebaseCrashlytics.instance;{{/firebase_crashlytics_feature}}{{#internet_cubit}}
  @lazySingleton
  InternetConnectionService get internetConnectionService =>
      InternetConnectionService();

  @injectable
  InternetConnectionCubit get internetConnectionCubit =>
      InternetConnectionCubit(internetConnectionService);{{/internet_cubit}}

  {{#share_feature}}{{^internet_cubit}}
  @lazySingleton
  InternetConnectionService get internetConnectionService =>
      InternetConnectionService();{{/internet_cubit}}

  @singleton
  FirebaseDynamicLinks get firebaseDynamicLinksInstance =>
      FirebaseDynamicLinks.instance;{{/share_feature}}
}