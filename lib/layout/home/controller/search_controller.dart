import 'dart:async';
import 'dart:math';

import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/layout/chat/args/chat_args.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/home/model/awaiting_model.dart';
import 'package:buddy/layout/home/model/confirmed_model.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchController {
  static final SearchController _instance = SearchController.internal();
  SearchController.internal();

  factory SearchController() {
    return _instance;
  }
  //Childs in our database
  DatabaseReference _searchRef;
  DatabaseReference _searchAwaitingRef;
  DatabaseReference _searchConfirmedRef;

  //initialize Refs
  Future<void> initSearchRefs() async {
    _searchRef =
        FirebaseDatabase.instance.reference().child("Home").child("Search");
    // DateHelper.currentDayInString();
    _searchConfirmedRef = _searchRef.child("Confirmed").child("2020-08-14");
    _searchAwaitingRef = _searchRef.child("Awaiting").child("2020-08-14");
    await _checkRefStatus();
  }

  //Initialize Methods, and listeners
  Future<void> initState(BuildContext context) async {
    await initSearchRefs();

    _searchAwaitingRef.onValue.listen((event) {
      Map<dynamic, dynamic> map = event.snapshot.value;
      if (map != null) {
        map.forEach((key, value) async {
          AwaitingModel awaitingModel = AwaitingModel.fromJson(key, value);

          if (awaitingModel.hasMatched == false &&
              awaitingModel.user != Config.user.email) {
            //Finds un matched user & set to true to lock matching process

            awaitingModel.hasMatched = true;
            await _searchAwaitingRef
                .child(awaitingModel.key)
                .set(awaitingModel.toJson());

            //Finds un matched user & set to true to lock matching process
            getByKey(_searchAwaitingRef, "user", Config.user.email)
                .then((DataSnapshot snapshot) async {
              print(Config.user.email);
              Map<dynamic, dynamic> map = snapshot.value;
              if (map != null) {
                map.forEach((key, value) async {
                  AwaitingModel awaitingModel =
                      AwaitingModel.fromJson(key, value);
                  awaitingModel.hasMatched = true;
                  await _searchAwaitingRef
                      .child(awaitingModel.key)
                      .set(awaitingModel.toJson());
                });
              }

              ConfirmedModel confirmedModel = ConfirmedModel(
                  timer: awaitingModel.timer,
                  users: [awaitingModel.user, Config.user.email],
                  channelName: Random().nextInt(100000));
              await _addUsersToConfirmed(confirmedModel);

              Navigator.of(context).pushReplacementNamed(ChatView.routeName,
                  arguments: ChatArgs(
                      channel: confirmedModel.channelName,
                      fromView: SearchingView.routeName));
            });
          }
        });
      }
    }, onError: (Object o) {
      //do something
    });
  }

  //functions
  DatabaseReference getReference() => _searchRef;

  Future<DataSnapshot> getByKey(
          DatabaseReference reference, String key, String value) =>
      reference.orderByChild(key).equalTo(value).once();

  Future<void> checkIfInConfirmed(BuildContext context) async {
    await _searchConfirmedRef.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      if (map != null) {
        map.forEach((key, value) async {
          ConfirmedModel confirmedModel = ConfirmedModel.fromJson(key, value);
          if (confirmedModel.users.contains(Config.user.email)) {
            Navigator.of(context).pushReplacementNamed(ChatView.routeName,
                arguments: ChatArgs(
                    channel: confirmedModel.channelName,
                    fromView: SearchingView.routeName));
          }
        });
      }
    });
  }

  Future<void> _checkRefStatus() async {
    await _searchRef
        .limitToFirst(1)
        .once()
        .then((value) => DebugHelper.green("FB: Home/Search"));

    await _searchAwaitingRef
        .limitToFirst(1)
        .once()
        .then((value) => DebugHelper.green("FB: Home/Search/Awaiting/Date"));

    await _searchConfirmedRef
        .limitToFirst(1)
        .once()
        .then((value) => DebugHelper.green("FB: Home/Search/Confirmed/Date"));
  }

  Future<void> addUserToAwaiting(AwaitingModel awaitingModel) async {
    await _searchAwaitingRef.once().then((DataSnapshot snapshot) {
      String value = snapshot.value.toString();

      if (!(value.contains(Config.user.email))) {
        _searchAwaitingRef.push().set(awaitingModel.toJson());
      }
    });
  }

  Future<void> deleteUserFromSearch(AwaitingModel awaitingModel) async {
    //needs to be implemented
    //await _searchAwaitingRef.child(awaitingModel.key).remove();
    // await _searchAwaitingRef.child(awaitingModel.key).remove();
  }

  Future<void> _addUsersToConfirmed(ConfirmedModel confirmedModel) async {
    await _searchConfirmedRef.once().then((DataSnapshot snapshot) {
      String value = snapshot.value.toString();

      if (!(value.contains(Config.user.email))) {
        _searchConfirmedRef.push().set(confirmedModel.toJson());
      } else {
        //This user did not finish session
      }
    });
  }
}
