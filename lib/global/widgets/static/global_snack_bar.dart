import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/layout/orrin/sharedWidgets/mascotImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GlobalSnackBar {
  GlobalSnackBar(String message,
      {SnackPosition snackPosition = SnackPosition.BOTTOM, int seconds = 3}) {
    double verticalHeight;

    switch (snackPosition) {
      case SnackPosition.TOP:
        verticalHeight = 0.001.sh;
        break;
      default:
        verticalHeight = 0.05.sh;
    }
    Get.rawSnackbar(
        backgroundColor: Colors.transparent,
        borderColor: Colors.transparent,
        borderWidth: 0.01.sw,
        duration: Duration(seconds: seconds),
        borderRadius: 0.sp,
        margin: EdgeInsets.symmetric(
            horizontal: 0.001.sw, vertical: verticalHeight),
        padding: EdgeInsets.zero,
        snackPosition: snackPosition,
        messageText: Row(
          children: [
            MascotImage(size: 0.1.sh),
            GlobalBoxContainer(
              boxShape: BoxShape.rectangle,
              boxShadow: BoxShadow(
                  color: Colors.black, blurRadius: 5, spreadRadius: -2),
              borderWidth: 2.sp,
              padding:
                  EdgeInsets.symmetric(vertical: 0.02.sh, horizontal: 0.02.sw),
              containerWidth: 0.7.sw,
              child: Center(
                child: AutoSizeText(
                  "Hi Buddy! " + message,
                  style: Global.appTheme.fonts.sfProText.subtitle1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ));
  }
}
