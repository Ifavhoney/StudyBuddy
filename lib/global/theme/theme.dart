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
      },
    ),
  );

  Fonts fonts = Fonts();
  IconColors iconColors = IconColors();
}
