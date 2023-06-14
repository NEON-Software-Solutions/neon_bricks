{{#share_feature}}import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';{{/share_feature}}{{^theme_switching}}
import 'package:{{project_name}}/core/core.dart';

final appTheme = kThemeLight;{{/theme_switching}}{{#authentication_own_backend_feature}}
// Backend

//TODO: configure all the following values
const kHostName = String.fromEnvironment(
  'TEMPLATE_API_URL',
  defaultValue: 'https://template-api.template.com',
);

const kApiVersion = 1;{{/authentication_own_backend_feature}}{{#share_feature}}

// Dynamic links
const kDynamicLinkUriPrefix = 'https://core-app.page.link'; //TODO
const kDynamicLinkAndroidParameters =
    AndroidParameters(packageName: 'com.example.example'); //TODO
const kDynamicLinkIosParameters = IOSParameters(
  bundleId: 'com.example.flutterCoreAppDynLinks', //TODO
  //appStoreId: 'bar-foo', //TODO
  // bundleId: 'com.foo.bar.dev', // <- for dev
  // appStoreId: '1603463149', // <- for dev
);{{/share_feature}}