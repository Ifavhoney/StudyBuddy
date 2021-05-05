class ConfirmedModel {
  String key;
  List<String> users;
  int timer;
  int beginTimeStamp;
  int endTimeStamp;
  int channelName;

  ConfirmedModel({this.users, this.timer, this.channelName, this.endTimeStamp});

  ///Retrieves these informations anytime you read firebase (JSON)
  ///Typically used when looping inside a Map, or seeking one snapshot
  ConfirmedModel.fromJson(String key, dynamic value)
      : this.users = List<String>.from(value["users"]),
        this.timer = value["timer"],
        this.channelName = value["channel"],
        this.key = key;

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "users": this.users,
      "channel": this.channelName,
      "timer": this.timer,
    };
  }
}
