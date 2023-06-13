import 'package:flutter/material.dart';
import 'style.dart';

// TYPO CONSTANTS -------------------------------------------------------------
const kFontFamilySFPro = 'SF-Pro';

const kH1FontSize = 20.0;
const kH2FontSize = 18.0;
const kH3FontSize = 16.0;

// Headers
const kTextH1 = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kH1FontSize,
    fontWeight: FontWeight.w700,
    color: kLightTextColor);
const kTextH2 = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kH2FontSize,
    fontWeight: FontWeight.w700,
    color: kLightTextColor);
const kTextH2Transparency = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kH2FontSize,
    fontWeight: FontWeight.w700,
    color: kLightTextColor50);
const kTextH3 = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kH3FontSize,
    fontWeight: FontWeight.w700,
    color: kLightTextColor);

// Body
const kBodyFontSizeSmall = 16.0;
const kBodyFontSizeLarge = 32.0;

const kTextBodySmall = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kBodyFontSizeSmall,
    color: kLightTextColor);
const kTextBodyLarge = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kBodyFontSizeLarge,
    color: kLightTextColor);

const kTextBodySmallSemiBold = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kBodyFontSizeSmall,
    color: kLightTextColor,
    fontWeight: FontWeight.w600);
const kTextBodyLargeSemiBold = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kBodyFontSizeLarge,
    color: kLightTextColor,
    fontWeight: FontWeight.w600);
const kTextBodySmallDisabled = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kBodyFontSizeSmall,
    color: kLightTextColor30);
const kTextBodyLargeDisabled = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kBodyFontSizeLarge,
    color: kLightTextColor30);

// Labels
const kLabelFontSize = 14.0;

const kTextLabel = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kLabelFontSize,
    color: kLightTextColor);
const kTextLabelBold = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kLabelFontSize,
    color: kLightTextColor,
    fontWeight: FontWeight.w700);

const kTextLabelDisabled = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kLabelFontSize,
    color: kLightTextColor50);
const kTextLabelDisabledBold = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kLabelFontSize,
    color: kLightTextColor50,
    fontWeight: FontWeight.w700);

const kTextHintPrimaryStyle = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kLabelFontSize,
    color: kLightTextColor30);

const kTextLabelError = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kLabelFontSize,
    color: kLightAccentTextColor);
const kTextLink = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kLabelFontSize,
    color: kLightAccentTextColor);

// Dialogs

const kDialogTitleFontSize = 20.0;

const kTextDialogTitle20 = TextStyle(
    fontFamily: kFontFamilySFPro,
    fontSize: kDialogTitleFontSize,
    fontWeight: FontWeight.w700,
    color: kLightTextColor);
