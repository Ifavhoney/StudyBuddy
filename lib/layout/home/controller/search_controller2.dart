import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/config.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
  DatabaseReference _searchChannelsRef;

  //initialize Refs
  Future<void> initSearchRefs() async {
    _searchRef =
        FirebaseDatabase.instance.reference().child("Home").child("Search");
    // DateHelper.currentDayInString();
    _searchConfirmedRef = _searchRef.child("Confirmed").child("2020-08-14");
    _searchAwaitingRef = _searchRef.child("Awaiting").child("2020-08-14");
    _searchChannelsRef = _searchRef.child("Channel").child("2020-08-14");
    await _checkRefStatus();
  }
  //Home/Search/Awaiting/

  Future<void> initState(BuildContext context) async {
    initSearchRefs();
    addUserToAwaiting();
    //call cloud function that adds user
    //if the user is already in, it ignores entry
    //on call? whaat do i pass in?
    //Stream listener for confirmed

    // await _matchUser();
    _searchConfirmedRef.onChildAdded.listen((event) async {
      await _searchChannelsRef.runTransaction((MutableData mutableData) async {
        mutableData.value = (mutableData.value ?? 0) + 1;
        return mutableData;
      });
      //This is where you would redirect the user
    });
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

  Future<void> deleteUserByEmail(String email) async {
    await getByKey(_searchAwaitingRef, "user", email)
        .then((DataSnapshot snapshot) {
      snapshot.value.forEach((key, value) {
        _searchAwaitingRef.child(key).remove();
        return;
      });
    });
  }

  Future<String> _matchUser() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('hello',
        options: HttpsCallableOptions(timeout: Duration(seconds: 5)));
    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'message': "ssss",
        },
      );
      DebugHelper.red("All good!!");
      // DebugHelper.red(result.data['response']);

    } catch (e) {
      print('caught generic exception');
      print(e);
    }
    return "";
  }

  //functions
  DatabaseReference getReference() => _searchRef;

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

    await _searchConfirmedRef
        .limitToFirst(1)
        .once()
        .then((value) => DebugHelper.green("FB: Home/Search/Confirmed/Date"));

    await _searchChannelsRef
        .limitToFirst(1)
        .once()
        .then((value) => DebugHelper.green("FB: Home/Search/Confirmed/Date"));
  }
}
