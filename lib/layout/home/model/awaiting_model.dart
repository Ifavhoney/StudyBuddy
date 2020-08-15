class AwaitingModel {
  //email
  //timer
  //waiting
  String key;
  String user;
  int timer;
  bool hasMatched;

  AwaitingModel({this.user, this.timer, this.hasMatched});

  ///Retrieves these informations anytime you read firebase (JSON)
  ///Typically used when looping inside a Map, or seeking one snapshot
  AwaitingModel.fromJson(String key, dynamic value)
      : this.user = value["user"],
        this.hasMatched = value["hasMatched"],
        this.timer = value["timer"],
        this.key = key;

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "user": this.user,
      "hasMatched": this.hasMatched,
      "timer": this.timer,
    };
  }
}
