import 'package:firebase_database/firebase_database.dart';

class ChatController {
  static final ChatController _instance = ChatController.internal();
  ChatController.internal();

  factory ChatController() {
    return _instance;
  }
}
