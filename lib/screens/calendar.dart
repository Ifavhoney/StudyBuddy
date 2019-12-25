import 'package:flutter/material.dart';
import 'webcam/camPortal.dart';
//cupertino_picker

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  TextEditingController channelName = new TextEditingController();
  DateTime now;
  String errorText;
  String hintText = "Enter Channel Name";
  String buttonText;

  @override
  void initState() {
    now = DateTime.now();

    super.initState();
  }

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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(
                child: ListView.separated(
                    itemCount: 7,
                    itemBuilder: (context, position) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 10,
                          child: Container(
                            height: MediaQuery.of(context).size.height / 8,
                            child: Card(
                              color: Colors.teal.shade200,
                              child: InkWell(
                                onDoubleTap: () {
                                  print("found!");
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ListTile(
                                      title: Text(
                                        "December 25, 2019",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      leading: Icon(Icons.calendar_today),
                                      trailing: Icon(
                                        Icons.touch_app,
                                        color: Colors.teal.shade100,
                                        size: 30,
                                      ),
                                      subtitle: Text(
                                          "Double Tap to book ? Meeting with FName"),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text("hello"),
                                        Text("hello"),
                                        Text("hello"),
                                        Text("hello"),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),

                              // the box shawdow property allows for fine tuning as aposed to shadowColor
                              boxShadow: [
                                new BoxShadow(
                                    color: Colors.lightBlue.shade100,
                                    // offset, the X,Y coordinates to offset the shadow
                                    offset: new Offset(0.0, 10.0),
                                    // blurRadius, the higher the number the more smeared look
                                    blurRadius: 30.0,
                                    spreadRadius: 4.0)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                          height: 20,
                        )),
              ),
            ],
          ),
        ));
  }
}
