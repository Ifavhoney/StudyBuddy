import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'webcam/camPortal.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'calendarPortal.dart';
//cupertino_picker

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime now;
  int week = 7;
  DateFormat dateFormat = DateFormat("E, MMMM d y");
  List<String> dates = [];
  String user;
  bool hasNotBooked = false;

  TextEditingController channelName = new TextEditingController();
  String errorText;
  String hintText = "Enter Channel Name";
  String buttonText;

  @override
  void initState() {
    super.initState();
    Auth().getCurrentUser().then((firebaseUser) {
      this.user = firebaseUser.email.toString();
    });
    int i = 0;
    now = DateTime.now();
    dates.add(dateFormat.format(now).toString());
    while (i != week) {
      dates.add(dateFormat.format(now.add(Duration(days: i + 1))).toString());
      i += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: Container(),
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
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 30),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(
                child: ListView.separated(
                    itemCount: dates.length,
                    itemBuilder: (context, i) {
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
                                  showDialog(
                                      context: this.context,
                                      builder: (context) => CalendarPortal(
                                            selectedDate: dates[i],
                                            user: this.user,
                                          ));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ListTile(
                                      title: Text(
                                        dates[i],
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      leading: Icon(Icons.calendar_today),
                                      trailing: Icon(
                                        Icons.touch_app,
                                        color: Colors.teal.shade100,
                                        size: 30,
                                      ),
                                      subtitle: Text("Double Tap to book"),
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
