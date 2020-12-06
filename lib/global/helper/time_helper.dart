import 'dart:async';

import 'package:get/get.dart';

class TimeHelper extends GetxController {
  Rx<Timer> primaryTimer = Timer(Duration.zero, () {}).obs;
  Rx<Timer> secondaryTimer = Timer(Duration.zero, () {}).obs;
  RxInt min = 0.obs;
  RxInt start = 0.obs;

  void startPrimaryTimer() {
    primaryTimer.value = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      if (min < 2) {
        primaryTimer.value.cancel();
        start.value = 60;
        startSecondaryTimer();
      } else {
        min = min - 1;
      }
    });

    //return new Timer(duration, endTimer);
  }

  void startSecondaryTimer() {
    secondaryTimer.value = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (start < 1) {
        secondaryTimer.value.cancel();
      } else {
        start = start - 1;
      }
    });

    //return new Timer(duration, endTimer);
  }

  void clean() async {
    if (primaryTimer.value.isActive == false) {
      secondaryTimer.value.cancel();
    }
    if (primaryTimer.value.isActive) {
      primaryTimer.value.cancel();
    }
  }
}
