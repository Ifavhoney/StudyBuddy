import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Awaiting {
  int key;
  String date;
  String time;
  String goal;
  String user;
  //Should be list
  bool hasMatched;

  Awaiting({this.user, this.goal, this.time, this.hasMatched});
  //Retrieves these informations anytime you read firebase
  Awaiting.fromSnapshot(DataSnapshot snapshot)
      : this.goal = snapshot.value["goal"],
        this.date = snapshot.value["date"],
        this.time = snapshot.value["time"],
        this.hasMatched = snapshot.value["hasMatched"],
        this.key = snapshot.value["key"],
        this.user = snapshot.value["user"];

//Firebase returns json data
  toJson() {
    return {
      "user": this.user,
      "goal": this.goal,
      "hasMatched": this.hasMatched

      /* ,"date": this.date,
      "time": this.time,
      "key": this.key,
      */
    };
  }
}
