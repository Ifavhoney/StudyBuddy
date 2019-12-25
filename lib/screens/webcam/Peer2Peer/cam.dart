import 'package:flutter/material.dart';

class Cam extends StatefulWidget {
  final String channelName;
  Cam({this.channelName});
  @override
  _CamState createState() => _CamState();
}

class _CamState extends State<Cam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("hello"),
      ),
    );
  }
}
