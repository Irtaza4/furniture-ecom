import 'package:flutter/material.dart';

class AppSpacing {
  // 8-Point Spacing System
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Screen Padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20.0);
  static const EdgeInsets screenPaddingWithTop = EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0);
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets bottomSheetPadding = EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 28.0);

  // Border Radius Tokens
  static const double radiusSmall = 12.0;
  static const double radiusInput = 16.0;
  static const double radiusButton = 18.0;
  static const double radiusCard = 24.0;
  static const double radiusHero = 32.0;
  static const double radiusPill = 999.0;
  static const double radiusNav = 28.0;
  static const double radiusSheet = 32.0;

  // BorderRadius objects
  static const BorderRadius roundedSmall = BorderRadius.all(Radius.circular(radiusSmall));
  static const BorderRadius roundedInput = BorderRadius.all(Radius.circular(radiusInput));
  static const BorderRadius roundedButton = BorderRadius.all(Radius.circular(radiusButton));
  static const BorderRadius roundedCard = BorderRadius.all(Radius.circular(radiusCard));
  static const BorderRadius roundedHero = BorderRadius.all(Radius.circular(radiusHero));
  static const BorderRadius roundedPill = BorderRadius.all(Radius.circular(radiusPill));
  static const BorderRadius roundedNav = BorderRadius.all(Radius.circular(radiusNav));
  static const BorderRadius roundedSheet = BorderRadius.only(
    topLeft: Radius.circular(radiusSheet),
    topRight: Radius.circular(radiusSheet),
  );
}
