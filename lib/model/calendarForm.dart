import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CalendarForm {
  int key;
  String date;
  String time;
  String goal;
  //Should be list
  String user1;
  String user2;
  bool hasMatched;

  CalendarForm({this.goal, this.time, this.hasMatched, this.user1, this.key});
  CalendarForm.fromSnapshot(DataSnapshot snapshot)
      : this.goal = snapshot.value["goal"],
        this.date = snapshot.value["date"],
        this.time = snapshot.value["time"],
        this.hasMatched = snapshot.value["hasMatched"],
        this.user1 = snapshot.value["user1"],
        this.user2 = snapshot.value["user2"],
        this.key = snapshot.value["key"];

  toJson() {
    return {};
  }
}
