import 'dart:async';
import 'package:buddy/debug/debug_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@LastModifiedBy: Jason NGuessan
class TimeHelper extends GetxController {
  Timer primaryTimer = Timer(Duration.zero, () {});
  Timer secondaryTimer = Timer(Duration.zero, () {});
  int min = 0;
  int second = 0;

  void init(int milliSeconds) {
    if (milliSeconds < 1000) {
      print("here??");
      reset(Get.context, forceBack: true);
    }

    print("milliseconds is " + milliSeconds.toString());
    min = (milliSeconds / (1000 * 60)).ceil();
    primaryTimer =
        Timer.periodic(Duration(milliseconds: 1000 * 60), (Timer timer) {
      DebugHelper.red("min is " + min.toString());

      if (min <= 1) {
        primaryTimer.cancel();
        second = 60;
        _startSecondaryTimer(Get.context);
      } else {
        min = min - 1;
      }
      update();
    });
  }

  void _startSecondaryTimer(BuildContext context) {
    secondaryTimer =
        Timer.periodic(Duration(milliseconds: 1 * 1000), (Timer timer) {
      if (second < 1) {
        reset(context);
      } else {
        second = second - 1;
      }
      update();
    });
  }

  void reset(BuildContext context, {bool forceBack = false}) async {
    if (forceBack == true) {
      print("forceback");
      // Future.delayed(Duration.zero, () => Navigator.of(context).pop());
    }

    if (primaryTimer.isActive == false) {
      // print("coming here ");
      secondaryTimer.cancel();
      //  Get.back();
    }
    if (primaryTimer.isActive) {
      print("nope, coming here instead");
      primaryTimer.cancel();
    }
    update();
  }
}
