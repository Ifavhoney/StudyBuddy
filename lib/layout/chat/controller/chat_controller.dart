import 'dart:async';

import 'package:buddy/global/global.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/chat/args/chat_args.dart';
import 'package:buddy/layout/chat/models/chat_model.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/orrin/model/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  TimeHelper timeHelper;
  RxBool showedFrienPopup = false.obs;

  //Childs in our database
  DatabaseReference _chatSearchRef;

  //other
  List<ChatModel> list;

  //initialize Refs
  void initChatRefs(String fromView, int channelName) {
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
  Future<void> initState(
      BuildContext context, String fromView, dynamic arguments) async {
    list = new List<ChatModel>();
    timeHelper = Get.find<TimeHelper>();
    initChatRefs(fromView, arguments.channel);
    print("initialized list??");
    //   _loadPrevMessages();
    if (SearchingView.routeName == fromView) {
      ChatArgs chatArgs = arguments;

      timeHelper.fromView = ChatView.routeName;
      for (String item in chatArgs.users) {
        UserModel userModel = await AuthController().getProfile(item);
        timeHelper.users.add(userModel);
      }
      await timeHelper.initAsync(chatArgs.timerInMs, context);

      await Future.delayed(Duration(seconds: 2));
      //Any changes that happens is refreshed is cleaned and re-added to
      _chatSearchRef
          .orderByChild("timestamp")
          .onChildAdded
          .listen((Event event) {
        list.add(ChatModel.fromJson(event.snapshot.value));
      });
    }
    print("we are here");
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
            email: Global.email,
            message: message,
          ).toJson());
    }
  }
}
