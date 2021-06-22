import 'dart:async';
import 'package:animations/animations.dart';
import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/user_config.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/chat/widget/chat_add_friend_popup.dart';
import 'package:buddy/layout/home/controller/search_controller2.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/nav_page/view_spner_chld_nav.dart';
import 'package:buddy/layout/nav_page/wait_searc_nav.dart';
import 'package:buddy/layout/orrin/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@LastModifiedBy: Jason NGuessan
class TimeHelper extends GetxController {
  Timer primaryTimer = Timer(Duration.zero, () {});
  Timer secondaryTimer = Timer(Duration.zero, () {});
  String fromView;
  RxList<UserModel> users = List<UserModel>().obs;
  SearchController _searchController = Get.find<SearchController>();

  int min = 0;
  int second = 0;
  RxInt asyncMilliseconds = 0.obs;

  Future<void> initAsync(int milliSeconds, BuildContext context) async {
    print("from view is " + fromView.toString());
    if (milliSeconds <= 60000) {
      print("fix time here");
      second = Duration(milliseconds: milliSeconds).inSeconds;
      print("calld here");
      await _searchController.initCount();
      update();
      startSecondaryTimer();
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
        startSecondaryTimer();
      } else {
        min = Duration(milliseconds: asyncMilliseconds.value).inMinutes;
      }
      update();
    });
  }

  void startSecondaryTimer({bool exit = false}) {
    secondaryTimer =
        Timer.periodic(Duration(milliseconds: 1 * 1000), (Timer timer) {
      if (second < 1) {
        reset();
        if (exit == true) {
          print("EXIT");
          if (fromView == ChatView.routeName) {
            print("hi there~~~~");
            Get.find<WaitSearNavBloc>().setPage(0);
            Get.off(ViewSpnerChldNav(child: WaitSearNav()),
                preventDuplicates: false);
          }
        }
      } else {
        second = second - 1;
      }
      update();
    });
  }

  void setSeconds(int value) {
    second = value;
    update();
  }

  void reset() async {
    secondaryTimer?.cancel();
    update();
  }
}
