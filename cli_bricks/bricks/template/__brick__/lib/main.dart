// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
// ignored in this file, bc internationalization does not work otherwise.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';{{#theme_switching}}
import 'package:flutter/foundation.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';{{/theme_switching}}
{{^theme_switching}}import 'package:bloc/bloc.dart';{{/theme_switching}}{{#local_cache_datasource}}
import 'package:hive_flutter/hive_flutter.dart';{{/local_cache_datasource}}
import 'package:neon_core/neon_core.dart';
import 'package:easy_localization/easy_localization.dart';{{#firebase_localization_loader_feature}}
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_remote_config_localization_loader/firebase_remote_config_localization_loader.dart';{{/firebase_localization_loader_feature}}{{#firebase_crashlytics_feature}}
import 'package:firebase_crashlytics/firebase_crashlytics.dart';{{/firebase_crashlytics_feature}}{{#initializes_firebase_app}}
import 'package:firebase_core/firebase_core.dart';
  
//TODO: if uncommenting this provokes an error, go setup firebase (check out the Setup Readme in the Auth Feature Folder!)
//import 'package:{{project_name}}/firebase_options.dart';{{/initializes_firebase_app}}
import 'package:{{project_name}}/app.dart';
import 'package:{{project_name}}/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();{{#local_cache_datasource}}
  await Hive.initFlutter();{{/local_cache_datasource}}
  await EasyLocalization.ensureInitialized();{{#initializes_firebase_app}}

  //TODO: if uncommenting this provokes an error, go setup firebase (check out the Setup Readme in the Auth Feature Folder!)
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);{{/initializes_firebase_app}}

  configureInjection(Env.dev);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  {{#firebase_localization_loader_feature}}
  final remoteConfig = getIt<FirebaseRemoteConfig>();

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );
  await remoteConfig.fetchAndActivate();

  // TODO: Add your supported locales here
  final supportedLocales = [const Locale('de'), const Locale('en')];

  final localizationLoader = FirebaseRemoteConfigLocalizationLoader(
    configData: FirebaseRemoteConfigData(
      remoteConfigInstance: remoteConfig,
      supportedLocales: supportedLocales,
      // TODO: Add your custom implementation of the naming here
      buildRemoteConfigStringFromLocale: (locale) =>
          'tran_${locale.languageCode}',
    ),
    // TODO: add your custom fallback path here
    fallbackAssetPath: 'assets/translations',
  );
  await localizationLoader.init();{{/firebase_localization_loader_feature}}

  {{#theme_switching}}HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );{{/theme_switching}}

  Bloc.observer = AppBlocObserver();{{#firebase_crashlytics_feature}}
  FlutterError.onError = getIt<FirebaseCrashlytics>().recordFlutterFatalError;{{/firebase_crashlytics_feature}}

  runApp(
    EasyLocalization({{^firebase_localization_loader_feature}}
      path: 'assets/translations',
      supportedLocales: [
        Locale('en'),
        Locale('de'),
      ],{{/firebase_localization_loader_feature}}{{#firebase_localization_loader_feature}}
      path: localizationLoader.path,
      assetLoader: localizationLoader.assetLoader,
      supportedLocales: supportedLocales,{{/firebase_localization_loader_feature}}
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      useFallbackTranslations: true,
      useOnlyLangCode: true,
      child: const App(),
    ),
  );
}
