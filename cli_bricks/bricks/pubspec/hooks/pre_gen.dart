import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = context.vars;

  //make sure its EITHER firebase OR own backend
  if (vars['authentication_own_backend_feature'] &&
      vars['authentication_firebase_auth_feature']) {
    throw Exception(
        'Pubspec Brick: You can only choose one authentication backend');
  }

  final pubspecPackages = _getPubspecPackages(vars);
  final pubspecSectionTitles = _getPubspecSectionTitles(pubspecPackages);

  context.vars = {
    'project_name': vars['project_name'],
    'project_description': vars['project_description'],
    ...pubspecSectionTitles,
    ...pubspecPackages,
  };
}

Map<String, bool> _getPubspecSectionTitles(Map<String, dynamic> packages) {
  final needsSystemInterfaceTitle =
      packages['needs_path_provider'] || packages['needs_hive'];

  final needsCodeGenTitle =
      packages['needs_retrofit'] || packages['needs_json_annotation'];

  final needsFirebaseTitle = packages['needs_firebase_core'] ||
      packages['needs_firebase_auth'] ||
      packages['needs_firebase_remote_config'] ||
      packages['needs_firebase_crashlytics'] ||
      packages['needs_firebase_dynamic_links'];

  final needsFeaturesTitle = packages['needs_share_plus'];

  return {
    'needs_system_interface_title': needsSystemInterfaceTitle,
    'needs_code_gen_title': needsCodeGenTitle,
    'needs_firebase_title': needsFirebaseTitle,
    'needs_features_title': needsFeaturesTitle,
  };
}

Map<String, bool> _getPubspecPackages(Map<String, dynamic> vars) {
  return {
    'needs_flutter_bloc': vars['internet_cubit'] ||
        vars['theme_switching'] ||
        vars['authentication_own_backend_feature'] ||
        vars['authentication_firebase_auth_feature'],
    'needs_equatable': vars['authentication_own_backend_feature'] ||
        vars['authentication_firebase_auth_feature'],
    'needs_hydrated_bloc': vars['theme_switching'],
    'needs_path_provider': vars['theme_switching'],
    'needs_hive':
        vars['local_cache_datasource'], //includes hive and  hive_flutter
    'needs_dio': vars['authentication_own_backend_feature'],
    'needs_dartz': vars['authentication_own_backend_feature'] ||
        vars['authentication_firebase_auth_feature'],
    'needs_retrofit': vars[
        'authentication_own_backend_feature'], //includes retrofit and retrofit_generator
    'needs_flutter_styled_toast': vars['toast_service'],
    'needs_json_annotation': vars['user_feature'],
    'needs_bloc_test': vars['authentication_own_backend_feature'] ||
        vars['authentication_firebase_auth_feature'],
    'needs_mocktail': vars['authentication_own_backend_feature'] ||
        vars['authentication_firebase_auth_feature'],
    'needs_firebase_core': vars['authentication_firebase_auth_feature'] ||
        vars['firebase_localization_loader_feature'] ||
        vars['firebase_crashlytics_feature'] ||
        vars['share_feature'],
    'needs_firebase_auth': vars['authentication_firebase_auth_feature'],
    'needs_firebase_remote_config':
        vars['firebase_localization_loader_feature'],
    'needs_easy_localization': vars['firebase_localization_loader_feature'],
    'needs_firebase_crashlytics': vars['firebase_crashlytics_feature'],
    'needs_firebase_dynamic_links': vars['share_feature'],
    'needs_share_plus': vars['share_feature'],
  };
}
