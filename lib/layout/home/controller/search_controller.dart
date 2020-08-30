import 'dart:async';
import 'dart:math';

import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/helper/date_helper.dart';
import 'package:buddy/layout/chat/models/chat_model.dart';
import 'package:buddy/layout/home/model/awaiting_model.dart';
import 'package:buddy/layout/home/model/confirmed_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchController {
  //Childs in our database
  DatabaseReference _searchRef;
  DatabaseReference _searchAwaitingRef;
  DatabaseReference _searchConfirmedRef;
  DatabaseReference _chatSearchRef;

  StreamSubscription<Event> _searchAwaitingSub;

  static final SearchController _instance = SearchController.internal();
  SearchController.internal();

  factory SearchController() {
    return _instance;
  }
  Future<void> initState(BuildContext context) async {
    _searchRef =
        FirebaseDatabase.instance.reference().child("Home").child("Search");
    _chatSearchRef =
        FirebaseDatabase.instance.reference().child("Chat").child("Search");

    // DateHelper.currentDayInString();
    _searchConfirmedRef = _searchRef.child("Confirmed").child("2020-08-14");
    _searchAwaitingRef = _searchRef.child("Awaiting").child("2020-08-14");
    _chatSearchRef = _chatSearchRef.child("2020-08-14");
    await checkRefStatus();

    //Need to check if user is already in the room

    _searchAwaitingSub = _searchAwaitingRef.onValue.listen((event) {
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
              Map<dynamic, dynamic> map = snapshot.value;
              if (map != null) {
                map.forEach((key, value) async {
                  awaitingModel = AwaitingModel.fromJson(key, value);
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
              ChatModel chatModel = ChatModel(messages: [" ", " "]);
              await addUsersToConfirmed(confirmedModel);
              print("created private event");
              await createPrivateChat(confirmedModel.channelName, chatModel);

              /*
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AudioView(
                    channelName: "1",
                  ),
                ),
              
              );
                */
            });
          }
        });
      }
    }, onError: (Object o) {
      //do something
    });
  }

  DatabaseReference getReference() => _searchRef;

  Future<DataSnapshot> getByKey(
          DatabaseReference reference, String key, String value) =>
      reference.orderByChild(key).equalTo(value).once();

  Future<void> checkRefStatus() async {
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

    await _chatSearchRef
        .limitToFirst(1)
        .once()
        .then((value) => DebugHelper.green("FB: Chat/Search/Date"));
  }

  Future<void> addUserToAwaiting(AwaitingModel awaitingModel) async {
    await _searchAwaitingRef.once().then((DataSnapshot dataSnapshot) {
      String value = dataSnapshot.value.toString();

      if (!(value.contains(Config.user.email))) {
        _searchAwaitingRef.push().set(awaitingModel.toJson());
      }
    });
  }

  Future<void> createPrivateChat(int channelName, ChatModel chatModel) async {
    await _chatSearchRef.child(channelName.toString()).set(chatModel.toJson());
  }

  Future<void> deleteUserFromSearch(AwaitingModel awaitingModel) async {
    //needs to be implemented
    //await _searchAwaitingRef.child(awaitingModel.key).remove();
    // await _searchAwaitingRef.child(awaitingModel.key).remove();
  }

  Future<void> addUsersToConfirmed(ConfirmedModel confirmedModel) async {
    await _searchConfirmedRef.once().then((DataSnapshot dataSnapshot) {
      String value = dataSnapshot.value.toString();

      if (!(value.contains(Config.user.email))) {
        _searchConfirmedRef.push().set(confirmedModel.toJson());
      } else {
        //This user did not finish session
      }
    });
  }
}
