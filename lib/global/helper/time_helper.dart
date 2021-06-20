import 'dart:async';
import 'package:animations/animations.dart';
import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/user_config.dart';
import 'package:buddy/layout/chat/widget/chat_add_friend_popup.dart';
import 'package:buddy/layout/home/controller/search_controller2.dart';
import 'package:buddy/layout/orrin/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@LastModifiedBy: Jason NGuessan
class TimeHelper extends GetxController {
  Timer primaryTimer = Timer(Duration.zero, () {});
  Timer secondaryTimer = Timer(Duration.zero, () {});
  String fromView;
  RxList<UserModel> users = List<UserModel>().obs;
  SearchController _searchController = new SearchController();

  int min = 0;
  int second = 0;
  RxInt asyncMilliseconds = 0.obs;

  Future<void> initAsync(int milliSeconds, BuildContext context) async {
    print("from view is " + fromView.toString());
    if (milliSeconds <= 60000) {
      second = Duration(milliseconds: milliSeconds).inSeconds;
      print("calld here");
      await _searchController.initCount();
      update();
      _startSecondaryTimer(context);
      return;
    }

    asyncMilliseconds.value = milliSeconds;
    await _searchController.initCount();
    min = Duration(milliseconds: milliSeconds).inMinutes;

    update();

    primaryTimer =
        Timer.periodic(Duration(milliseconds: 10000), (Timer timer) async {
      if (min <= 1) {
        primaryTimer.cancel();
        second = Duration(milliseconds: asyncMilliseconds.value).inSeconds;
        _startSecondaryTimer(context);
      } else {
        min = Duration(milliseconds: asyncMilliseconds.value).inMinutes;
      }
      update();
    });
  }

  void init(int milliSeconds) {
    if (milliSeconds < 1000) {
      reset(Get.context, forceBack: true);
    }

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
    secondaryTimer.cancel();
    update();
  }
}
