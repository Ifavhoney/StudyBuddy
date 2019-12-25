import 'package:flutter/material.dart';
import 'webcam/camPortal.dart';
//cupertino_picker

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  TextEditingController channelName = new TextEditingController();

  String errorText;
  String hintText = "Enter Channel Name";
  String buttonText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Calendar"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              //Does something
              showDialog(
                context: context,
                builder: (_) => CamPortal(),
              );
            },
          )
        ],
      ),
    );
  }
}
