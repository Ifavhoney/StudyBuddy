import 'dart:async';

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

  //other
  List<ChatModel> list;

  //initialize Refs
  Future<void> initChatRefs(
      String fromView, int channelName, String fbKey) async {
    if (SearchingView.routeName == fromView) {
      _chatSearchRef = FirebaseDatabase.instance
          .reference()
          .child("Chat")
          .child("Search")
          .child("2020-08-14")
          .child(channelName.toString())
          .child("Messages");
    }
  }

  //Initialize Refs, and listeners
  Future<void> initState(BuildContext context, String fromView, int channelName,
      String fbKey) async {
    list = new List<ChatModel>();
    await initChatRefs(fromView, channelName, fbKey);
  
    //   _loadPrevMessages();
    if (SearchingView.routeName == fromView) {
      //Any changes that happens is refreshed is cleaned and re-added to
      _chatSearchRef
          .orderByChild("timestamp")
          .onChildAdded
          .listen((Event event) {
        list.add(ChatModel.fromJson(event.snapshot.value));
      });
    }
  }

  DatabaseReference getReference(String fromView) {
    if (SearchingView.routeName == fromView) {
      return _chatSearchRef;
    }
    return _chatSearchRef;
  }

  Future<void> sendMessage(String message, String fromView) async {
    if (SearchingView.routeName == fromView) {
      await _chatSearchRef.push().set(ChatModel(
            email: Config.user.email,
            message: message,
          ).toJson());
    }
  }
}
