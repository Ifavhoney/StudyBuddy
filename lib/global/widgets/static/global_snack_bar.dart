import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/global/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GlobalSnackBar {
  static void main(String message,
      {SnackPosition snackPosition = SnackPosition.BOTTOM}) {
    return Get.snackbar("Notice", "Email Cannot be Empty",
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        borderWidth: 0.01.sw,
        colorText: Colors.black,
        messageText: AutoSizeText(
          message,
          style: Global.appTheme.fonts.sfProText.subtitle1
              .copyWith(fontWeight: FontWeight.bold),
        ),
        snackPosition: snackPosition);
  }
}
