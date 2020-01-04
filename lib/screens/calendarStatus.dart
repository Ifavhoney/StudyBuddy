import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:study_buddy/model/firebase_database_util.dart';
import 'package:study_buddy/data/data.dart';

class CalendarStatus extends StatefulWidget {
  final String user;
  CalendarStatus(this.user);
  @override
  _CalendarStatusState createState() => _CalendarStatusState();
}

class _CalendarStatusState extends State<CalendarStatus> {
  String child1 = 'Peer2Strangers';
  String child2 = 'Appointments';
  String child3 = 'Awaiting';
  String child4 = 'Confirmed';
  List<String> dates;

  String currentDate;
  DateFormat dateFormat;
  // instance of util class
  FirebaseDatabaseUtil databaseUtil;
  DatabaseReference _database1 = FirebaseDatabase.instance.reference();
  DatabaseReference _database2 = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    dates = Data.days(7);
    _database1 = _database1.child(child1).child(child2).child(child3);
    _database2 = _database2.child(child1).child(child2).child(child4);
    dateFormat = DateFormat("yyyy-MM-dd");
    currentDate = dateFormat.format(DateTime.now());
    databaseUtil = new FirebaseDatabaseUtil();
    databaseUtil.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("Appointment Status"),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 18, 0, 30),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Confirmed Appointment",
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 7,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              color: Colors.teal.shade100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Time:\nChannel Name:\nConfirmed With:"),
                                  Container(
                                    height: 400,
                                    width: 400,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          100, 0, 0, 0),
                                      child: displayDate(dates[i]),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        "Awaiting Appointment",
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 7,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              color: Colors.teal.shade100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Time:\nChannel Name:\nConfirmed With:"),
                                  Container(
                                    height: 400,
                                    width: 400,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          100, 0, 0, 0),
                                      child: displayDate(dates[i]),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        "Cancelled Appointment",
                        style: Theme.of(context)
                            .textTheme
                            .display1
                            .copyWith(fontSize: 20),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 7,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              color: Colors.teal.shade100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Time:\nChannel Name:\nConfirmed With:"),
                                  Container(
                                    height: 400,
                                    width: 400,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          100, 0, 0, 0),
                                      child: displayDate(dates[i]),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget displayDate(String date) {
    return FirebaseAnimatedList(
      query: _database2,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, DataSnapshot res,
          Animation<double> animation, int i) {
        return FutureBuilder<DataSnapshot>(
            future: _database2.child(res.key).once(),
            builder: (BuildContext context, snapshot) {
              String channel;
              String time;
              List<dynamic> users;

              if (snapshot.hasData) {
                //shows where the user has an apppointment
                if (snapshot.data.value["users"]
                        .toString()
                        .contains(widget.user) &&
                    snapshot.data.value["date"].toString().contains(date)) {
                  channel = snapshot.data.value["channelName"].toString();
                  time = snapshot.data.value["time"];
                  //while loop
                  users = snapshot.data.value["users"];
                  return time != null
                      ? showcaseStatus(time, channel, users)
                      : Text("");
                } else if (!snapshot.data.value["users"]
                        .toString()
                        .contains(widget.user) &&
                    !snapshot.data.value["date"].toString().contains(date)) {
                  return Text("empty");
                } else {
                  return Container();
                }

                //Shows where the user does not have an appointment

              } else {
                return Text("");
              }
            });
      },
    );
  }

  Widget showcaseStatus(String time, String channel, List<dynamic> users) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              time,
            ),
            Text(
              channel,
            ),
            //Shows to whom
            Text(!users[0].toString().contains(widget.user) == true
                ? users[0]
                : users[1]),
          ],
        ),
      ],
    );
  }
}
