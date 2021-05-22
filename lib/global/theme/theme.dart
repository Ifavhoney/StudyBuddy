import 'package:buddy/global/theme/fonts/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors/icon_colors.dart';

///@LastModifiedBy: Jason NGuessan
/*
Fonts are bigger on this app
https://api.flutter.dev/flutter/material/TextTheme-class.html
*/

class AppTheme {
  ///<summary>
  ///backgroundColor: Colors.white
  ///
  ///accentColor: Colors.black
  ///</summary>
  ThemeData mainTheme = ThemeData(
    backgroundColor: Colors.white,
    accentColor: Colors.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.sp),
      ),
      //keep this way for white text, and white background
      primary: Colors.white,
      onPrimary: Colors.white,
      enableFeedback: false,
      elevation: 2,
    )),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  ///<summary>
  ///Headline1: 80sp, bold
  ///
  ///headline2: 40sp, bold
  ///
  ///headline3: 26sp, bold
  ///
  ///headline4: 24sp, bold
  ///
  ///headline5: 20sp, bold
  ///
  ///headline6: 18sp
  ///
  ///subtitle1: 16sp
  ///
  ///subtitle2: 12sp
  ///
  ///</summary>
  TextTheme segoeUi = Fonts.segoeUi;

  ///<summary>
  ///headline2: 40sp, bold

  ///headline4: 24sp, bold
  ///
  ///headline5: 22sp, bold
  ///
  ///headline6: 18sp
  ///
  ///subtitle1: 16sp
  ///
  ///bodyText1: 14sp
  ///
  ///subtitle2: 12sp
  ///</summary>
  TextTheme sfProText = Fonts.sfProText;

  ///<summary>
  ///
  ///headline3: 26sp, bold
  ///
  ///bodyText1: 14sp, bold
  ///
  ///subtitle2: 10sp
  ///</summary>
  TextTheme nexa = Fonts.nexa;

  ///<summary>
  ///{}
  ///</summary>
  Map<String, Color> homeViewIcons = IconColors.homeView;

  ///<summary>
  ///"arrowBack": Color(0xFFE1C2EB)
  ///</summary>
  Map<String, Color> loginViewIcons = IconColors.loginView;

  ///<summary>
  ///
  ///"arrowBack": Color(0xFFFFFFFF)
  ///
  ///"add": Color(0xFF707070)
  ///</summary>
  Map<String, Color> signupViewIcons = IconColors.signupView;

  ///<summary>
  ///
  ///"arrowBack": Color(0xFFFFFFFF)
  ///
  ///"add": Color(0xFF707070)
  ///</summary>
  Map<String, Color> preferenceViewIcons = IconColors.preferencesView;

  ///<summary>
  ///
  ///"timer": Color(0xFFC5D3E0)
  ///
  ///"cam": Color(0xFFC5D3E0)
  ///
  ///"mic": Color(0xFFC5D3E0)
  ///
  ///"person": Color(0xFFC5D3E0)
  ///
  ///"switch": Color(0xFFC5D3E0)
  ///
  ///end": Color(0xFFD0021B)
  ///</summary>
  Map<String, Color> camViewIcons = IconColors.camView;

  ///<summary>
  ///
  ///"checkmark": Color(0xFF7C79FF)
  ///
  ///"timer": Color(0xFF7C79FF)
  ///
  ///"location": Color(0xFF272727)
  ///
  ///"add": Color(0xFF504DE5)
  ///</summary>
  Map<String, Color> audioViewIcons = IconColors.audioView;

  ///<summary>
  ///
  ///"call": Color(0xFFB3B2FF)
  ///
  ///"cam": Color(0xFFB3B2FF)
  ///
  ///"notification": Color(0xFF504DE5)
  ///
  ///inactive": Color(0xFFB5B5B5)
  ///
  ///"search": Color(0xFFC6C6C6)
  ///</summary>
  Map<String, Color> friendViewIcons = IconColors.friendView;

  ///<summary>
  ///
  ///"logout": Color(0xFF504DE5)
  ///
  ///</summary>
  Map<String, Color> settingsViewIcons = IconColors.settingsView;

  ///<summary>
  ///
  ///"search": Color(0xFF737BCE)
  ///</summary>
  Map<String, Color> waitingViewIcons = IconColors.waitingView;

  ///<summary>
  ///
  ///"arrowBack": Color(0xFFE1C2EB)
  ///</summary>
  Map<String, Color> searchingViewIcons = IconColors.searchingView;

  ///<summary>
  ///
  ///"active": Color(0xFF7C79FF)
  ///
  ///"inactive": Color(0xFF6F8BA4)
  ///
  ///"search": Color(0xFF8BB1FB)
  ///</summary>
  Map<String, Color> bottomNavigationBarIcons = IconColors.bottomNavigationBar;
}
