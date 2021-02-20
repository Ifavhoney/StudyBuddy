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

//https://medium.com/flutter-community/how-to-start-with-flutter-firebase-and-cloud-functions-1d1aa38c4d82
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

  //Initialize Methods, and listeners
  Future<void> initState(BuildContext context) async {
    await initSearchRefs();

    TransactionResult transactionResult;

    //creates channel
    _searchConfirmedRef.onChildAdded.listen((event) async {
      print(event.snapshot.value);
      //print("hiiii");
      transactionResult = await _searchChannelsRef
          .runTransaction((MutableData mutableData) async {
        mutableData.value = (mutableData.value ?? 0) + 1;

        return mutableData;
      });
      if (transactionResult.committed) {
        //print("committed");
      }
    });
    await getByKey(_searchAwaitingRef, "hasMatched", false)
        .then((DataSnapshot snapshot) {
      print(snapshot.value.toString());
      if (snapshot.value == null)
        addUserToAwaiting(AwaitingModel(
            hasMatched: false, timer: 3, user: Config.user.email));
    });

    _searchAwaitingRef.onValue.listen((event) async {
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

            addUserToAwaiting(AwaitingModel(
                hasMatched: true, timer: 3, user: Config.user.email));
            return;
          }
        });
      } else {
        await addUserToAwaiting(AwaitingModel(
            hasMatched: false, timer: 3, user: Config.user.email));
      }

/*


            
*/

      /*
            getByKey(_searchAwaitingRef, "user", Config.user.email)
                .then((DataSnapshot snapshot) async {
              AwaitingModel userModel = AwaitingModel.fromJson(key, value);
              print(
                  "OTHER PRIORITY IS is " + awaitingModel.priority.toString());

              print("priority is " + userModel.priority.toString());
              print("USER is " + Config.user.email);

             
            });
            */
      /*
            
              */

/*
              Navigator.of(context).pushReplacementNamed(ChatView.routeName,
                  arguments: ChatArgs(
                      channel: confirmedModel.channelName,
                      fromView: SearchingView.routeName));
              
            });
                    */
    });

    _searchAwaitingRef.onChildAdded.listen((event) async {
      Map<dynamic, dynamic> map = event.snapshot.value;
      AwaitingModel awaitingModel = AwaitingModel.fromJson("", map);
      //one user is going to initiate child added
      if (awaitingModel.hasMatched && Config.user.email == awaitingModel.user) {
        //print("comes here");
        await getByKey(_searchAwaitingRef, "hasMatched", true)
            .then((DataSnapshot snapshot) async {
          Map<dynamic, dynamic> map = snapshot.value;
          map.forEach((key, value) async {
            AwaitingModel userModel = AwaitingModel.fromJson(key, value);

            if (userModel.user != awaitingModel.user) {
              _searchChannelsRef.limitToFirst(1).once().then((value) {
                int channel = (value.value ?? 0) + 1;
                print("i come here once right?");

                ConfirmedModel confirmedModel = ConfirmedModel(
                    timer: awaitingModel.timer,
                    users: [userModel.user, awaitingModel.user],
                    channelName: channel);
                _addUsersToConfirmed(confirmedModel);
                deleteUserFromSearch(awaitingModel);
                awaitingModel.user = userModel.user;
                deleteUserFromSearch(awaitingModel);
              });

              print("confirmed!");
            }
          });
        });
      }
    });
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

  Future<DataSnapshot> getByKey(
          DatabaseReference reference, String key, dynamic value) =>
      reference.orderByChild(key).equalTo(value).once();

  Future<bool> checkIfInConfirmed() async {
    bool userIsHere = false;

    await _searchConfirmedRef.once().then((DataSnapshot snapshot) async {
      String value = snapshot.value.toString();

      if ((value.contains(Config.user.email))) {
        userIsHere = true;
        //_searchConfirmedRef.push().set(confirmedModel.toJson());

        /*
            Navigator.of(context).pushReplacementNamed(ChatView.routeName,
                arguments: ChatArgs(
                    channel: confirmedModel.channelName,
                    fromView: SearchingView.routeName));
                    */
        //   _searchConfirmedRef.push().set(confirmedModel.toJson());
      } else {
        //This user did not finish session
      }
    });
    print("User is here" + userIsHere.toString());
    return userIsHere;
  }

  Future<AwaitingModel> checkIfAwaiting() async {
    AwaitingModel awaitingModel;
    await _searchAwaitingRef.limitToFirst(1).once().then((snapshot) {
      Map<dynamic, dynamic> map = snapshot.value;
      if (map != null) {
        map.forEach((key, value) async {
          awaitingModel = AwaitingModel.fromJson(key, value);
        });
      }
    });
    return awaitingModel;
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
    print("delete model" + awaitingModel.user);
    await _searchAwaitingRef.child(awaitingModel.key).remove();
  }

  Future<void> _addUsersToConfirmed(ConfirmedModel confirmedModel) async {
    _searchConfirmedRef.push().set(confirmedModel.toJson());

/*
    await _searchConfirmedRef.once().then((DataSnapshot snapshot) async {
      String value = snapshot.value.toString();
      print("value is here");
      print(value.toString());

      if (!(value.contains(Config.user.email))) {
        //_searchConfirmedRef.push().set(confirmedModel.toJson());

        /*
            Navigator.of(context).pushReplacementNamed(ChatView.routeName,
                arguments: ChatArgs(
                    channel: confirmedModel.channelName,
                    fromView: SearchingView.routeName));
                    */
        //   _searchConfirmedRef.push().set(confirmedModel.toJson());
      } else {
        //This user did not finish session
      }
    });
      */
  }
}
