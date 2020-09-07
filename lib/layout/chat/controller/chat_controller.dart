import 'dart:async';

import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/layout/chat/models/chat_model.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatController {
  static final ChatController _instance = ChatController.internal();
  ChatController.internal();

  factory ChatController() {
    return _instance;
  }

  //Childs in our database
  DatabaseReference _chatSearchRef;

  //initialize Refs
  Future<void> initChatRefs(String fromView, int channelName) async {
    if (SearchingView.routeName == fromView) {
      _chatSearchRef = FirebaseDatabase.instance
          .reference()
          .child("Chat")
          .child("Search")
          .child("2020-08-14")
          .child(channelName.toString())
          .child("messages");
    }

    await _checkRefStatus(fromView);
  }

  //Initialize Refs, and listeners
  Future<void> initState(
      BuildContext context, String fromView, int channelName) async {
    await initChatRefs(fromView, channelName);
    if (SearchingView.routeName == fromView) {}
  }

  Future<void> _checkRefStatus(String fromView) async {
    if (SearchingView.routeName == fromView) {
      await _chatSearchRef
          .limitToFirst(1)
          .once()
          .then((value) => DebugHelper.green("FB: Chat/Search/Date"));
    }
  }

  Future<void> createPrivateChat(int channelName, ChatModel chatModel) async {
    await _chatSearchRef.child(channelName.toString()).set(chatModel.toJson());
  }

  Future<void> sendMessage(String message) async {
    print("sending message");

    await _chatSearchRef
        .set(ChatModel(email: Config.user.email, message: message).toJson());
  }
}
