import 'package:buddy/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter/services.dart' show rootBundle;

class HtmlHelper extends StatelessWidget {
  final dynamic text;

  HtmlHelper(this.text);

  static Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme segoeUi = Global.appTheme.fonts.segoeUi;
    return Container(
      child: Html(
        data: text,
        style: {
          "p": Style(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              fontSize: FontSize(segoeUi.subtitle1.fontSize + 2.sp)),
          "a": Style(
              margin: EdgeInsets.zero,
              fontSize: FontSize(segoeUi.subtitle1.fontSize + 2.sp),
              color: Colors.blue,
              textDecorationColor: Colors.blue),

          "h1": Style(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            fontSize: FontSize(segoeUi.headline2.fontSize + 2.sp),
          ),
          'h2': Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              fontSize: FontSize(segoeUi.headline2.fontSize)),
          'h3': Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              fontSize: FontSize(segoeUi.headline3.fontSize)),
          'h4': Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              fontSize: FontSize(segoeUi.headline4.fontSize)),
          'h5': Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              fontSize: FontSize(segoeUi.headline5.fontSize)),
          'h6': Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              fontSize: FontSize(segoeUi.headline6.fontSize)),
          //h2,h3,h4,h5,h6"
        },
        onLinkTap: (url) async {
          if (await canLaunch(url)) {
            launch(url);
          }
        },
      ),
    );
  }
}
