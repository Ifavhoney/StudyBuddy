import 'package:buddy/theme/colors/icon_colors.dart';
import 'package:buddy/theme/fonts/fonts.dart';
import 'package:flutter/material.dart';

/*
Fonts are bigger on this app
https://api.flutter.dev/flutter/material/TextTheme-class.html
*/

class AppTheme {
  ///<summary>
  ///
  ///backgroundColor: Colors.white
  ///
  ///accentColor: Color(0xFFF8FAFF)
  ///
  ///cardColor: Color(0xFFB9D1FF)
  ///</summary>
  static ThemeData mainTheme = ThemeData(
    backgroundColor: Colors.white,
    accentColor: Color(0xFFF8FAFF),
    cardColor: Color(0xFFB9D1FF),
  );

  ///<summary>
  ///
  ///Headline1: 80px, bold
  ///
  ///headline2: 40px, bold
  ///
  ///headline3: 26px, bold
  ///
  ///headline4: 24px, bold
  ///
  ///headline5: 20px, bold
  ///
  ///headline6: 18px
  ///
  ///subtitle1: 16px
  ///
  ///subtitle2: 12px
  ///
  ///</summary>
  static TextTheme segoeUi = Fonts.segoeUi;

  ///<summary>
  ///headline4: 24px, bold
  ///
  ///headline5: 22px, bold
  ///
  ///headline6: 18px
  ///
  ///subtitle1: 16px
  ///
  ///bodyText1: 14px
  ///
  ///subtitle2: 12px
  ///</summary>
  static TextTheme sfProText = Fonts.sfProText;

  ///<summary>
  ///
  ///headline3: 26px, bold
  ///
  ///bodyText1: 14px, bold
  ///
  ///subtitle2: 10px
  ///</summary>
  static TextTheme nexa = Fonts.nexa;

  static Map<String, Color> homeScreenIcons = IconColors.homeScreen;
  static Map<String, Color> loginScreenIcons = IconColors.loginScreen;
  static Map<String, Color> signupScreenIcons = IconColors.signupScreen;
  static Map<String, Color> preferenceScreenIcons =
      IconColors.preferencesScreen;
  static Map<String, Color> camScreenIcons = IconColors.camScreen;
  static Map<String, Color> audioScreenIcons = IconColors.audioScreen;
  static Map<String, Color> friendScreenIcons = IconColors.friendScreen;
  static Map<String, Color> settingsScreenIcons = IconColors.settingsScreen;
  static Map<String, Color> searchingScreenIcons = IconColors.searchingScreen;
  static Map<String, Color> bottomNavigationBarIcons =
      IconColors.bottomNavigationBar;
}
