import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_buddy/model/calendar/Appointments/confirmed.dart';
import 'package:study_buddy/model/calendar/appointments/awaiting.dart';
import 'webcam/camPortal.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'calendarPortal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:study_buddy/model/firebase_database_util.dart';

//cupertino_picker

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  String child1 = 'Peer2Strangers';
  String child2 = 'Appointments';
  String child3 = 'Awaiting';
  String child4 = 'Confirmed';
  DateTime now;
  int week = 7;
  //DateFormat dateFormat = DateFormat("E, MMMM d y");
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DatabaseReference _database2 = FirebaseDatabase.instance.reference();

  List<String> dates = [];
  String user;
  bool hasNotBooked = false;

  TextEditingController channelName = new TextEditingController();
  String errorText;
  String hintText = "Enter Channel Name";
  String buttonText;

  FirebaseDatabaseUtil databaseUtil;
  @override
  void initState() {
    super.initState();

    int i = 0;
    now = DateTime.now();
    dates.add(dateFormat.format(now).toString());
    while (i != week) {
      dates.add(dateFormat.format(now.add(Duration(days: i + 1))).toString());
      i += 1;
    }

    Auth().getCurrentUser().then((firebaseUser) {
      this.user = firebaseUser.email.toString();
    });

    databaseUtil = new FirebaseDatabaseUtil();
    databaseUtil.initState();
    _database2 = _database2.child(child1).child(child2).child(child4);

    //Read through Awaiting, if it shows false, update the card
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    databaseUtil.dispose();
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
          padding: const EdgeInsets.fromLTRB(0, 18, 0, 30),
          child: FirebaseAnimatedList(
              query: _database2.orderByKey().limitToFirst(7),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int i) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[showCard(snapshot, i)],
                  ),
                );
              }),
        ));
  }

  Widget showCard(DataSnapshot res, int i) {
    if (res.value.toString().length >= 2) {}

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
                          selectedDate: res.key,
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
                      res.key,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    leading: Icon(Icons.calendar_today),
                    trailing: Icon(
                      Icons.touch_app,
                      color: Colors.teal.shade100,
                      size: 30,
                    ),
                    subtitle: Text("Double Tap to book"),
                  ),

                  //Display correct content
                  confirmedData(res)
                  /*
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("hello"),
                      Text("hello"),
                      Text("hello"),
                      Text("hello"),
                    ],
                  )
                  */
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
  }

  Widget confirmedData(DataSnapshot res) {
    //used for keeping track of changes
    List<String> userData;
    //Proving we have data @ that exact location or else it'll throw an error
    if (res.value.toString().length >= 2) {
      Map<dynamic, dynamic> values;
      values = res.value;

      //print(values.values);
      if (values.containsKey("00:00")) {
        print("true");
        _database2.child(res.key).child("00:00").once().then((snapshot) {
          Map<dynamic, dynamic> values;
          values = snapshot.value;
          print(values.containsValue("woot@gmail.com"));
        });
      }
    }
    return Container();
  }

  Future<DataSnapshot> getUserData(
      DatabaseReference database, String selectedDate) async {
    return await database.child(selectedDate).once();
  }
}
