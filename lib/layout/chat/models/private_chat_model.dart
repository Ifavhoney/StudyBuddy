class PrivateChatModel {
  String user;
  String message;

  PrivateChatModel({this.user, this.message});

  ///Retrieves these informations anytime you read firebase (JSON)
  ///Typically used when looping inside a Map, or seeking one snapshot
  PrivateChatModel.fromJson(dynamic value)
      : this.user = value["user"],
        this.message = value["message"];

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "user": this.user,
      "message": this.message,
    };
  }
}
