import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:study_buddy/model/firebase_database_util.dart';

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
  List<String> modifiedSet = List<String>();
  String currentDate;
  DateFormat dateFormat;
  // instance of util class
  FirebaseDatabaseUtil databaseUtil;
  DatabaseReference _database1 = FirebaseDatabase.instance.reference();
  DatabaseReference _database2 = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
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
                      Expanded(
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[],
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
                } else {
                  return Container();
                }

                //Shows where the user does not have an appointment

              } else {
                print("no data");
                return Text("");
              }
            });
      },
    );
  }

  Widget showcaseStatus(String time, String channel, List<dynamic> users) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            time,
          ),
          Text(
            channel,
          ),
          //Shows to wh om
          Text(!users[0].toString().contains(widget.user) == true
              ? users[0]
              : users[1]),
        ],
      ),
    );
  }
}
