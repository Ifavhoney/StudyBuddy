import 'dart:async';
import 'package:buddy/debug/debug_helper.dart';
import 'package:get/get.dart';

///@LastModifiedBy: Jason NGuessan
class TimeHelper extends GetxController {
  Timer primaryTimer = Timer(Duration.zero, () {});
  Timer secondaryTimer = Timer(Duration.zero, () {});
  int min = 0;
  int second = 0;
  int count = 0;

  void init(int milliSeconds) {
    primaryTimer =
        Timer.periodic(Duration(milliseconds: 1000 * 60), (Timer timer) {
      min = (milliSeconds / (1000 * 60)).ceil();
      if (min <= 1) {
        primaryTimer.cancel();
        second = 60;
        _startSecondaryTimer();
      } else {
        min = min - 1;
      }
      update();
    });
  }

  incrementCount() {
    count++;
    update();
  }

  void _startSecondaryTimer() {
    secondaryTimer =
        Timer.periodic(Duration(milliseconds: 1 * 1000), (Timer timer) {
      if (second < 1) {
        reset();
      } else {
        second = second - 1;
      }
      update();
    });
  }

  void reset() async {
    if (primaryTimer.isActive == false) {
      secondaryTimer.cancel();
      Get.back();
    }
    if (primaryTimer.isActive) {
      primaryTimer.cancel();
    }
    update();
  }
}
