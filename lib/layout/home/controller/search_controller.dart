import 'dart:async';

import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/helper/date_helper.dart';
import 'package:buddy/layout/home/model/search_model.dart';
import 'package:firebase_database/firebase_database.dart';

class SearchController {
  //Childs in our database
  DatabaseReference _searchRef;
  StreamSubscription<Event> _searchSub;

  static final SearchController _instance = SearchController.internal();
  SearchController.internal();

  factory SearchController() {
    return _instance;
  }
  void initState() {
    _searchRef =
        FirebaseDatabase.instance.reference().child("Home").child("Search");
    _searchRef
        .limitToFirst(1)
        .once()
        .then((value) => DebugHelper.green("FB: Home/Search"));

    _searchSub = _searchRef.onValue.listen((event) {
      // DebugHelper.red("Fires when this reference has been updated");
    }, onError: (Object o) {
      //do something
    });
  }

  DatabaseReference getReference() => _searchRef;

  _isAlreadySearching() async {
    await _searchRef
        .child("Awaiting")
        .child(DateHelper.currentDayInString())
        .once();
  }

  addUserToAwaiting(SearchModel searchModel) async {
    /*
    return await _isAlreadySearching().then((DataSnapshot dataSnapshot) {
      DebugHelper.red(dataSnapshot.value.toString());
      String value = dataSnapshot.value.toString();
      if (!value.contains(Config.user.email)) {
        _searchRef
            .child("Awaiting")
            .child(DateHelper.currentDayInString())
            .push()
            .set(searchModel.toJson());
      }
    });
      */
  }
}
