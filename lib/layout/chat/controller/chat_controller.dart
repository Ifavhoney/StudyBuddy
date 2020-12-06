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

  //other
  List<ChatModel> list = new List();

  //initialize Refs
  Future<void> initChatRefs(String fromView, int channelName) async {
    if (SearchingView.routeName == fromView) {
      _chatSearchRef = FirebaseDatabase.instance
          .reference()
          .child("Chat")
          .child("Search")
          .child("2020-08-14")
          .child(channelName.toString())
          .child("Messages");
    }

    await _checkRefStatus(fromView);
  }

  //Initialize Refs, and listeners
  Future<void> initState(
      BuildContext context, String fromView, int channelName) async {
    await initChatRefs(fromView, channelName);

    if (SearchingView.routeName == fromView) {
      await _chatSearchRef.once().then((DataSnapshot snapshot) {
        _sortMessages(snapshot.value);
      });
      //Any changes that happens is refreshed is cleaned and re-added to
      _chatSearchRef.onValue.listen((Event event) {
        _sortMessages(event.snapshot.value);
      });
    }
  }

  DatabaseReference getReference(String fromView) {
    if (SearchingView.routeName == fromView) {
      return _chatSearchRef;
    }
    return _chatSearchRef;
  }

  Future<void> _checkRefStatus(String fromView) async {
    if (SearchingView.routeName == fromView) {
      await _chatSearchRef
          .limitToFirst(1)
          .once()
          .then((value) => DebugHelper.green("FB: Chat/Search/Date/Messages"));
    }
  }

  void _sortMessages(dynamic value) {
    list = new List();

    Map<dynamic, dynamic> map = value;

    if (map != null) {
      map.forEach((key, value) {
        // print(value);

        list.add(ChatModel.fromJson(value));
      });

      list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }
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
