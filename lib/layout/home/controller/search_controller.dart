import 'dart:async';
import 'dart:math';

import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/helper/date_helper.dart';
import 'package:buddy/layout/home/model/awaiting_model.dart';
import 'package:buddy/layout/home/model/confirmed_model.dart';
import 'package:firebase_database/firebase_database.dart';

class SearchController {
  //Childs in our database
  DatabaseReference _searchRef;
  DatabaseReference _searchAwaitingRef;
  DatabaseReference _searchConfirmedRef;

  StreamSubscription<Event> _searchAwaitingSub;

  static final SearchController _instance = SearchController.internal();
  SearchController.internal();

  factory SearchController() {
    return _instance;
  }
  Future<void> initState() async {
    _searchRef =
        FirebaseDatabase.instance.reference().child("Home").child("Search");

    _searchConfirmedRef = _searchRef.child("Confirmed").child("2020-08-14");
    _searchAwaitingRef = _searchRef.child("Awaiting").child("2020-08-14");

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

            String user = awaitingModel.user;
            DebugHelper.red("found user " + awaitingModel.user);
            awaitingModel.hasMatched = true;

            await _searchAwaitingRef
                .child(awaitingModel.key)
                .set(awaitingModel.toJson());
                
            await _searchAwaitingRef
                .child(awaitingModel.key)
                .set(awaitingModel.toJson());

            ConfirmedModel confirmedModel = ConfirmedModel(
                timer: awaitingModel.timer,
                users: [awaitingModel.user, Config.user.email],
                channelName: Random().nextInt(100000));

            await addUsersToConfirmed(confirmedModel);
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
  }

  Future<void> addUserToAwaiting(AwaitingModel awaitingModel) async {
    await _searchAwaitingRef.once().then((DataSnapshot dataSnapshot) {
      String value = dataSnapshot.value.toString();

      if (!(value.contains(Config.user.email))) {
        _searchAwaitingRef.push().set(awaitingModel.toJson());
      }
    });
  }

  Future<void> addUsersToConfirmed(ConfirmedModel confirmedModel) async {
    await _searchConfirmedRef.once().then((DataSnapshot dataSnapshot) {
      String value = dataSnapshot.value.toString();

      if (!(value.contains(Config.user.email))) {
        _searchConfirmedRef.push().set(confirmedModel.toJson());
      }
    });
  }
}
