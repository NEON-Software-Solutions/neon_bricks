import 'package:flutter/material.dart';

// COLOR CONSTANTS ------------------------------------------------------------

const kColorPrimaryLight = Color.fromRGBO(119, 115, 175, 1);
const kColorPrimaryDark = Colors.green;

const kColorAccentLight = Color.fromRGBO(254, 196, 210, 1);
const kColorAccentDark = Color.fromRGBO(57, 1, 14, 1);

const kColorScaffoldBackgroundLight = Colors.white;
const kColorScaffoldBackgroundDark = Colors.black;

const kColorSuccess = Color.fromRGBO(138, 225, 111, 1);
const kColorErrorLight = Color.fromARGB(255, 236, 79, 79);
const kColorErrorDark = Color.fromRGBO(102, 0, 0, 1);

const kColorBlack = Color.fromRGBO(0, 0, 0, 1);
const kColorBlack50 = Color.fromRGBO(0, 0, 0, 0.5);
const kColorBlack30 = Color.fromRGBO(0, 0, 0, 0.3);

const kColorWhite = Color.fromRGBO(255, 255, 255, 1);
const kColorWhite50 = Color.fromRGBO(255, 255, 255, 0.5);
const kColorWhite30 = Color.fromRGBO(255, 255, 255, 0.3);

const kColorTransparent = Color.fromRGBO(255, 255, 255, 0);
final kColorDisabledLight = const Color(0xffFFFFFF).withOpacity(0.5);
final kColorDisabledDark = kColorDisabledLight;

const kLightTextColor = kColorBlack;
const kLightTextColor50 = kColorBlack50;
const kLightTextColor30 = kColorBlack30;
const kLightAccentTextColor = kColorAccentLight;

const kDarkTextColor = kColorWhite;
const kDarkTextColor50 = kColorWhite50;
const kDarkTextColor30 = kColorWhite30;
const kDarkAccentTextColor = kColorAccentDark;

final kMediumShadowColor = kColorBlack.withOpacity(0.2);

// GRADIENT CONSTANTS --------------------------------------------------------
//e.g.:

const LinearGradient kExampleGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xff0F2C4E),
    Color(0xff5D5B86),
    Color(0xffB26297),
    Color(0xff741662),
    Color(0xff5D5A85),
    Color(0xff0F2C4E),
  ],
  stops: [0, 0.2107, 0.3782, 0.5791, 0.8063, 1],
);
