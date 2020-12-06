import 'package:buddy/global/helper/date_helper.dart';

class ConfirmedModel {
  String key;
  List<dynamic> users;
  int timer;
  int beginTimeStamp;
  int endTimeStamp;
  int channelName;

  ConfirmedModel({this.users, this.timer, this.channelName});

  ///Retrieves these informations anytime you read firebase (JSON)
  ///Typically used when looping inside a Map, or seeking one snapshot
  ConfirmedModel.fromJson(String key, dynamic value)
      : this.users = value["users"],
        this.timer = value["timer"],
        this.beginTimeStamp = value["beginTimeStamp"],
        this.endTimeStamp = value["endTimeStamp"],
        this.channelName = value["channelName"],
        this.key = key;

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "users": this.users,
      "channelName": this.channelName,
      "timer": this.timer,
      "beginTimeStamp": DateTime.now().millisecondsSinceEpoch,
      "endTimeStamp": DateHelper.getEndTimeInTimestamp(this.timer)
    };
  }
}
