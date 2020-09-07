class ChatModel {
  String message;
  String email;

  ChatModel({this.message, this.email});

  ///Retrieves these informations anytime you read firebase (JSON)
  ///Typically used when looping inside a Map, or seeking one snapshot
  ChatModel.fromJson(dynamic value)
      : this.message = value["message"],
        this.email = value["email"];

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "message": message,
      "email": email,
    };
  }
}
