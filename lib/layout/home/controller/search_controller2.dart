import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/layout/chat/args/chat_args.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:buddy/layout/home/model/awaiting_model.dart';
import 'package:buddy/layout/home/model/confirmed_model.dart';
import 'package:buddy/layout/home/view/searching_view.dart';

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

    _searchConfirmedRef.onChildAdded.listen((event) async {
      if (event.snapshot.value.toString().contains(Config.user.email)) {
        DebugHelper.red(event.snapshot.value.toString());
        ConfirmedModel confirmedModel =
            ConfirmedModel.fromJson(event.snapshot.key, event.snapshot.value);
        Navigator.of(context).pushNamed(ChatView.routeName,
            arguments: ChatArgs(
                channel: 1,
                fromView: SearchingView.routeName,
                timerInMs: confirmedModel.timer,
                users: confirmedModel.users,
                fbKey: confirmedModel.key));
      }
    });
    addUserToAwaiting();
  }

  Future<void> addUserToAwaiting() async {
    AwaitingModel awaitingModel =
        AwaitingModel(hasMatched: false, timer: 3, user: Config.user.email);
    await _searchAwaitingRef.once().then((DataSnapshot snapshot) {
      String value = snapshot.value.toString();

      if (!(value.contains(Config.user.email))) {
        _searchAwaitingRef.push().set(awaitingModel.toJson());
      }
    });
  }

  Future<DataSnapshot> getByKey(
          DatabaseReference reference, String key, dynamic value) =>
      reference.orderByChild(key).equalTo(value).once();

  Future<void> removeFromAwaiting(String email) async {
    _searchAwaitingCountRef.reference().runTransaction((mutable) async {
      mutable.value -= 1;
      return mutable;
    });

    await getByKey(_searchAwaitingRef, "user", email)
        .then((DataSnapshot snapshot) {
      snapshot.value.forEach((key, value) async {
        await _searchAwaitingRef.child(key).remove();

        return;
      });
    });
  }

  DatabaseReference getReference() => _searchRef;
}
