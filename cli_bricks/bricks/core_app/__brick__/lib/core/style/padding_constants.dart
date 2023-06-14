import 'package:flutter/cupertino.dart';

const _kSmallPadding = 5.0;
const _kMediumPadding = 15.0;
const _kLargePadding = 30.0;

const kPadLeftSmall = EdgeInsets.only(left: _kSmallPadding);
const kPadLeftMedium = EdgeInsets.only(left: _kMediumPadding);
const kPadLeftLarge = EdgeInsets.only(left: _kLargePadding);

const kPadRightSmall = EdgeInsets.only(right: _kSmallPadding);
const kPadRightMedium = EdgeInsets.only(right: _kMediumPadding);
const kPadRightLarge = EdgeInsets.only(right: _kLargePadding);

const kPadBottomSmall = EdgeInsets.only(bottom: _kSmallPadding);
const kPadBottomMedium = EdgeInsets.only(bottom: _kMediumPadding);
const kPadBottomLarge = EdgeInsets.only(bottom: _kLargePadding);

const kPadTopSmall = EdgeInsets.only(top: _kSmallPadding);
const kPadTopMedium = EdgeInsets.only(top: _kMediumPadding);
const kPadTopLarge = EdgeInsets.only(top: _kLargePadding);

const kPadVertSmall = EdgeInsets.symmetric(vertical: _kSmallPadding);
const kPadVertMedium = EdgeInsets.symmetric(vertical: _kMediumPadding);
const kPadVertLarge = EdgeInsets.symmetric(vertical: _kLargePadding);

const kPadHorSmall = EdgeInsets.symmetric(horizontal: _kSmallPadding);
const kPadHorMedium = EdgeInsets.symmetric(horizontal: _kMediumPadding);
const kPadHorLarge = EdgeInsets.symmetric(horizontal: _kLargePadding);

const kPadSmall = EdgeInsets.all(_kSmallPadding);
const kPadMedium = EdgeInsets.all(_kMediumPadding);
const kPadLarge = EdgeInsets.all(_kLargePadding);

const kBoxConstraints = BoxConstraints(maxWidth: kMaxWidth);
const kPostItemConstraints = BoxConstraints(maxWidth: kMaxWidth);

const kAppBarConstraints = BoxConstraints(maxWidth: 850);
const kButtonConstraints = BoxConstraints(maxWidth: 450);
const kChatPageConstraints = BoxConstraints(maxWidth: 500);

const kMaxWidth = 800.0;
bool isWidthOverLimit(BuildContext context) =>
    MediaQuery.of(context).size.width > kMaxWidth;
double maxWidth(BuildContext context) =>
    MediaQuery.of(context).size.width > kMaxWidth
        ? kMaxWidth
        : MediaQuery.of(context).size.width;
