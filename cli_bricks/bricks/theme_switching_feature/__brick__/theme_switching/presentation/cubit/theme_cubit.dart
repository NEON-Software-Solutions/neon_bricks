import 'package:flutter/material.dart';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:{{project_name}}/core/core.dart';

final _defaultTheme = kThemeLight;

@injectable
class ThemeCubit extends HydratedCubit<ThemeData> {
  ThemeCubit() : super(_defaultTheme);

  void switchTheme() {
    emit(state.brightness == Brightness.light ? kThemeDark : _defaultTheme);
  }

  @override
  ThemeData? fromJson(Map<String, dynamic> json) =>
      json['brightness'] == 'light' ? kThemeLight : kThemeDark;

  @override
  Map<String, dynamic>? toJson(ThemeData state) =>
      {'brightness': state.brightness == Brightness.light ? 'light' : 'dark'};
}
