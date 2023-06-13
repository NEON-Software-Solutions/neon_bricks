// THEMES ---------------------------------------------------------------------

import 'package:flutter/material.dart';

import 'color_constants.dart';
import 'typo_constants.dart';

final kThemeLight = ThemeData(
  brightness: Brightness.light,
  primaryColor: kColorPrimaryLight,
  highlightColor: kColorAccentLight,
  backgroundColor: kColorAccentLight,
  scaffoldBackgroundColor: kColorScaffoldBackgroundLight,
  errorColor: kColorErrorLight,
  disabledColor: kColorDisabledLight,
  splashColor: kColorTransparent,
  textTheme: TextTheme(
    displayLarge: kTextH1,
    displayMedium: kTextH2,
    displaySmall: kTextH3,
    bodyLarge: kTextBodyLarge,
    bodySmall: kTextBodySmall,
    labelLarge: kTextLabel,
    labelMedium: kTextLabel,
    labelSmall: kTextLabel.copyWith(color: kLightTextColor.withOpacity(0.3)),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: kColorPrimaryLight,
    onPrimary: kColorBlack,
    secondary: kColorAccentLight,
    onSecondary: kColorBlack,
    error: kColorErrorLight,
    onError: kColorBlack,
    background: kColorScaffoldBackgroundLight,
    onBackground: kColorBlack,
    surface: kColorAccentLight,
    onSurface: kColorBlack,
  ),
);

final kThemeDark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: kColorPrimaryDark,
  highlightColor: kColorAccentDark,
  backgroundColor: kColorAccentDark,
  scaffoldBackgroundColor: kColorScaffoldBackgroundDark,
  splashColor: kColorTransparent,
  disabledColor: kColorDisabledDark,
  errorColor: kColorErrorDark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: kColorPrimaryDark,
    onPrimary: kColorWhite,
    secondary: kColorAccentDark,
    onSecondary: kColorWhite,
    error: kColorErrorDark,
    onError: kColorWhite,
    background: kColorScaffoldBackgroundDark,
    onBackground: kColorWhite,
    surface: kColorAccentDark,
    onSurface: kColorWhite,
  ),
  textTheme: TextTheme(
    displayLarge: kTextH1.copyWith(color: kDarkTextColor),
    displayMedium: kTextH2.copyWith(color: kDarkTextColor),
    displaySmall: kTextH3.copyWith(color: kDarkTextColor),
    bodyLarge: kTextBodyLarge.copyWith(color: kDarkTextColor),
    bodySmall: kTextBodySmall.copyWith(color: kDarkTextColor),
    labelLarge: kTextLabel.copyWith(color: kDarkTextColor),
    labelMedium: kTextLabel.copyWith(color: kDarkTextColor),
    labelSmall: kTextLabel.copyWith(color: kDarkTextColor.withOpacity(0.3)),
  ),
);
