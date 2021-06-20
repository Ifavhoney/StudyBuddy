import 'package:animations/animations.dart';
import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/layout/auth/widget/copywriting_popup.dart';
import 'package:buddy/layout/chat/args/chat_args.dart';
import 'package:buddy/layout/chat/controller/chat_controller.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/chat/widget/chat_add_friend_popup.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:buddy/layout/nav_page/view_spner_chld_nav.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:buddy/layout/home/model/awaiting_model.dart';
import 'package:buddy/layout/home/model/confirmed_model.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:get/get.dart';

class SearchController {
  //Singleton ensures one instance of a class to ever be created
  static final SearchController _instance = SearchController.internal();
  SearchController.internal();

  factory SearchController() {
    return _instance;
  }

  //Childs in our database
  DatabaseReference _searchRef;
  DatabaseReference _searchAwaitingRef;
  DatabaseReference _searchConfirmedRef;
  DatabaseReference _searchAwaitingCountRef;
  String confirmedKey;

  //initialize Refs
  Future<void> initSearchRefs() async {
    _searchRef =
        FirebaseDatabase.instance.reference().child("Home").child("Search");
    // DateHelper.currentDayInString();
    _searchConfirmedRef = _searchRef.child("Confirmed").child("2020-08-14");
    _searchAwaitingRef = _searchRef.child("Awaiting").child("2020-08-14");

    _searchAwaitingCountRef = _searchRef
        .child("Count")
        .child("Awaiting")
        .child("2020-08-14")
        .child("id");
  }

  Future<void> initState(BuildContext context) async {
    initSearchRefs();

    _searchAwaitingCountRef.keepSynced(true);
    matchingListener(context);
    addUserToAwaiting();
  }

  Future<void> matchingListener(BuildContext context) async {
    _searchConfirmedRef.onChildAdded.listen((event) async {
      if (event.snapshot.value.toString().contains(Global.email)) {
        DebugHelper.red(event.snapshot.value.toString());
        ConfirmedModel confirmedModel =
            ConfirmedModel.fromJson(event.snapshot.key, event.snapshot.value);
        toChatView(context, confirmedModel);
      }
    });
  }

  Future<void> checkIfInConfirmed(BuildContext context) async {
    await _searchConfirmedRef.once().then((DataSnapshot snapshot) async {
      String value = snapshot.value.toString();
      print("global.email is " + Global.email.toString());
      if ((value.contains(Global.email))) {
        snapshot.value.forEach((key, value) async {
          ConfirmedModel confirmedModel = ConfirmedModel.fromJson(key, value);
          if (confirmedModel.users.contains(Global.email))
            toChatView(context, confirmedModel);
        });
      } else {
        return;
      }
    });
  }

  Future<void> toChatView(BuildContext context, ConfirmedModel confirmedModel) {
    confirmedKey = confirmedModel.key;
    ChatArgs args = ChatArgs(
        channel: confirmedModel.channelName,
        fromView: SearchingView.routeName,
        timerInMs: confirmedModel.timer,
        users: confirmedModel.users,
        fbKey: confirmedModel.key);

    return Get.off(ViewSpnerChldNav(child: ChatView()),
        arguments: {"chatArgs": args});
  }

  Future<void> initCount() async {
    TimeHelper timeHelper = Get.find<TimeHelper>();

    _searchConfirmedRef
        .child(confirmedKey)
        .onChildChanged
        .listen((event) async {
      timeHelper.asyncMilliseconds.value = event.snapshot.value - 8000;
    });

    _searchConfirmedRef
        .child(confirmedKey)
        .onChildRemoved
        .listen((event) async {
      showModal(
          context: (Get.context),
          configuration: FadeScaleTransitionConfiguration(
              barrierDismissible: true,
              reverseTransitionDuration: Duration(milliseconds: 10),
              transitionDuration: Duration(milliseconds: 1000)),
          builder: (context) {
            return ChatAddFriendPopup(timeHelper.users
                .where((user) => user.email != Global.email)
                .first);
          });
    });
  }

  Future<void> addUserToAwaiting() async {
    AwaitingModel awaitingModel =
        AwaitingModel(hasMatched: false, timer: 3, user: Global.email);
    await _searchAwaitingRef.once().then((DataSnapshot snapshot) {
      String value = snapshot.value.toString();

      if (!(value.contains(Global.email))) {
        _searchAwaitingRef.push().set(awaitingModel.toJson());
      }
    });
  }

  Future<DataSnapshot> getByKey(
          DatabaseReference reference, String key, dynamic value) =>
      reference.orderByChild(key).equalTo(value).once();

  Future<void> removeFromAwaiting(String email) async {
    await getByKey(_searchAwaitingRef, "user", email)
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        snapshot.value.forEach((key, value) async {
          if (value["user"] == email) {
            await _searchAwaitingRef.child(key).remove();
            _searchAwaitingCountRef.reference().runTransaction((mutable) async {
              mutable.value -= 1;
              return mutable;
            });
            return;
          }
        });
      }
    });
  }

  DatabaseReference getReference() => _searchRef;
}
