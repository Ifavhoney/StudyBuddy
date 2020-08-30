class ChatModel {
  List<String> messages;

  ChatModel({this.messages});

  ///Retrieves these informations anytime you read firebase (JSON)
  ///Typically used when looping inside a Map, or seeking one snapshot
  ChatModel.fromJson(dynamic value) : this.messages = value["messages"];

//Sends Data back to firebase in JSON format
  toJson() {
    return {
      "messages": this.messages,
    };
  }
}
