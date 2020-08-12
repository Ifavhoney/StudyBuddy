import 'dart:async';

import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/layout/home/model/search_model.dart';
import 'package:firebase_database/firebase_database.dart';

class SearchController {
  //Childs in our database
  DatabaseReference _searchReference;
  static final SearchController _instance = SearchController.internal();
  SearchController.internal();

  factory SearchController() {
    return _instance;
  }
  void initState() {
    _searchReference =
        FirebaseDatabase.instance.reference().child("Home").child("Search");
    _searchReference
        .once()
        .then((value) => DebugHelper.green("Search Reference"));
  }

  DatabaseReference getReference() => _searchReference;
}
