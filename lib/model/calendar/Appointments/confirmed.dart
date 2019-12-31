import 'package:firebase_database/firebase_database.dart';

class Confirmed {
  String key;
  String time;
  String date;

  List<String> users;
  int channelName;

  Confirmed({this.users, this.time, this.date, this.channelName});
  //Retrieves these informations anytime you read firebase (JSON)

  Confirmed.fromSnapshot(DataSnapshot snapshot)
      : this.users = snapshot.value["users"],
        this.time = snapshot.value["time"],
        this.date = snapshot.value["time"],
        this.channelName = snapshot.value["channelName"],
        this.key = snapshot.key;

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "users": this.users,
      "time": this.time,
      "date": this.date,
      "channelName": this.channelName
    };
  }
}
