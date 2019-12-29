import 'package:firebase_database/firebase_database.dart';

class Awaiting {
  String key;
  String time;
  String goal;
  String user;
  bool hasMatched;

  Awaiting({this.user, this.goal, this.time, this.hasMatched});
  //Retrieves these informations anytime you read firebase (JSON)
  Awaiting.fromSnapshot(DataSnapshot snapshot)
      : this.goal = snapshot.value["goal"],
        this.hasMatched = snapshot.value["hasMatched"],
        this.user = snapshot.value["user"],
        this.key = snapshot.key;

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "user": this.user,
      "goal": this.goal,
      "hasMatched": this.hasMatched
    };
  }
}
