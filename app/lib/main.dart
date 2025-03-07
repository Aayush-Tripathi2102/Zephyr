import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zephyr/borrow_screen.dart';
import 'package:zephyr/collateral_screen.dart';
import 'package:zephyr/collateral_selection_screen.dart';
import 'package:zephyr/credit_Score_screen.dart';
import 'package:zephyr/dashboard_screen.dart';
import 'package:zephyr/home.dart';
import 'package:zephyr/loan_confirmation_screen.dart';
import 'package:zephyr/navigation_screen.dart';
import 'package:zephyr/repay_screen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      home: AppNavigator()
    );
  }
}

abstract final class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: Color(0xFF9333EA),
      primaryContainer: Color(0xFFD8B4FE),
      primaryLightRef: Color(0xFF9333EA),
      secondary: Color(0xFF7E22CE),
      secondaryContainer: Color(0xFFE9D5FF),
      secondaryLightRef: Color(0xFF7E22CE),
      tertiary: Color(0xFFA855F7),
      tertiaryContainer: Color(0xFFF3E8FF),
      tertiaryLightRef: Color(0xFFA855F7),
      appBarColor: Color(0xFFA855F7),
      error: Color(0xFFB00020),
      errorContainer: Color(0xFFFCD9DF),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );



  static ThemeData dark = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: Color(0xFFA855F7),
      primaryContainer: Color(0xFF6B21A8),
      primaryLightRef: Color(0xFF9333EA),
      secondary: Color(0xFFD8B4FE),
      secondaryContainer: Color(0xFF581C87),
      secondaryLightRef: Color(0xFF7E22CE),
      tertiary: Color(0xFFE9D5FF),
      tertiaryContainer: Color(0xFF4C1D95),
      tertiaryLightRef: Color(0xFFA855F7),
      appBarColor: Color(0xFF4C1D95),
      error: Color(0xFFCF6679),
      errorContainer: Color(0xFFB1384E),
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}


