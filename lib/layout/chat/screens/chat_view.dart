import 'package:buddy/layout/chat/widget/generic_body.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final String fromView;

  const ChatView({Key key, this.fromView}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GenericBody(
      title: "Messages",
      body: Text("hi"),
    ));
  }
}

/*

*/
