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
        body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 18, 0, 30),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: FirebaseAnimatedList(
                    query: _database2
                        .orderByKey()
                        .limitToFirst(7)
                        .startAt(currentDate),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int i) {
                      print(snapshot.key);
                    },
                  ),
                )
              ],
            )));
  }
}
