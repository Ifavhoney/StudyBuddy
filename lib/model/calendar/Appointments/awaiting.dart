import 'package:firebase_database/firebase_database.dart';

class Awaiting {
  String key;
  String endTime;
  String goal;
  String user;
  List<dynamic> timeConflicts;

  bool hasMatched;

  Awaiting({this.user, this.goal, this.hasMatched, this.endTime});

  //Retrieves these informations anytime you read firebase (JSON)
  Awaiting.fromSnapshot(DataSnapshot snapshot)
      : this.goal = snapshot.value["goal"],
        this.hasMatched = snapshot.value["hasMatched"],
        this.user = snapshot.value["user"],
        this.endTime = snapshot.value["endTime"],
        // this.timeConflicts = snapshot.value["timeConflicts"],
        this.key = snapshot.key;

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "user": this.user,
      "goal": this.goal,
      "hasMatched": this.hasMatched,
      "endTime": this.endTime,
      //"timeConflicts": this.timeConflicts,
    };
  }
}
