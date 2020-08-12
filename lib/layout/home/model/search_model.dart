import 'package:firebase_database/firebase_database.dart';

class SearchModel {
  //email
  //timer
  //waiting
  String key;
  String user;
  String timer;
  bool hasMatched;

  SearchModel({this.user, this.timer, this.hasMatched});

  //Retrieves these informations anytime you read firebase (JSON)
  SearchModel.fromSnapshot(DataSnapshot snapshot)
      : this.user = snapshot.value["user"],
        this.hasMatched = snapshot.value["hasMatched"],
        this.timer = snapshot.value["timer"],
        this.key = snapshot.key;

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "user": this.user,
      "hasMatched": this.hasMatched,
      "timer": this.timer,
    };
  }
}
