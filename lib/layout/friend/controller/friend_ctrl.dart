import 'dart:async';

import 'package:buddy/global/global.dart';
import 'package:buddy/layout/chat/models/chat_model.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class FriendCtrl extends GetxController {
  //Childs in our database
  DocumentReference _friendRef;

  //other
  List<ChatModel> list;

  //initialize Refs
  Future<void> initFriendRef(String fromView) async {
    if (ChatView.routeName == fromView) {
      _friendRef =
          FirebaseFirestore.instance.collection("Friends").doc(Global.email);
    }
  }

  //Initialize Refs, and listeners
  Future<void> initState(BuildContext context, String fromView) async {
    list = new List<ChatModel>();
    await initFriendRef(fromView);

    //   _loadPrevMessages();
    if (ChatView.routeName == fromView) {
      _friendRef.get().then((snapshot) {
        if (snapshot.exists) {
          //Chceck if the friend at hand exists in friendList
          //if does, provide a different popup & don't call broadcaststream
          //else do the rest
          print("exists!!!!");
        } else {
          _friendRef.set({"peer2group": [], "peer2peer": []});
        }
      });

      //Any changes that happens is refreshed is cleaned and re-added to
      _friendRef.snapshots().asBroadcastStream(onListen: (snapshot) {});
    }
  }

  Future getFriends() async {
    //  QuerySnapshot qn = await _friendRef.get()

    // QuerySnapshot qn = await db.collection("Users").where("Reason For Joining", isEqualTo: "Career").getDocuments();
    //  return qn.documents;
  }

  DocumentReference getReference(String fromView) {
    if (ChatView.routeName == fromView) {
      return _friendRef;
    }
    return _friendRef;
  }

  Future<void> sendMessage(String message, String fromView) async {}
}
