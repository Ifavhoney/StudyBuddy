import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:study_buddy/model/calendar/Appointments/awaiting.dart';
import 'package:study_buddy/model/calendar/Appointments/confirmed.dart';
import 'package:study_buddy/model/firebase_database_util.dart';

class CalendarPortal extends StatefulWidget {
  final String selectedDate;
  final String user;

  CalendarPortal({this.selectedDate, this.user});
  @override
  _CalendarPortalState createState() => _CalendarPortalState();
}

class _CalendarPortalState extends State<CalendarPortal>
    with SingleTickerProviderStateMixin {
  String child1 = 'Peer2Strangers';
  String child2 = 'Appointments';
  String child3 = 'Awaiting';
  String child4 = 'Confirmed';

  // instance of util class
  FirebaseDatabaseUtil databaseUtil;

  DateTime dateTime = DateTime(2020, 1, 1, 0, 0);
  String time;
  List<String> allUsers = new List<String>();
  TextEditingController _goal = new TextEditingController();
  List<String> errorText = new List<String>();
  int i;
  //neccessary to set the duration of our animation
  AnimationController controller;
  //0-1 indicates wether running or completed
  Animation<double> scaleAnimation;
  DatabaseReference _database = FirebaseDatabase.instance.reference();
  DatabaseReference _database2 = FirebaseDatabase.instance.reference();

  //Listens to when changes happen
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  @override
  void initState() {
    _database = _database.child(child1).child(child2).child(child3);
    _database2 = _database2.child(child1).child(child2).child(child4);

    databaseUtil = FirebaseDatabaseUtil();
    databaseUtil.initState();

    //databaseUtil.initState();

    i = 0;
    errorText.add("");
    errorText.add("Text cannot be empty");

    //  errorText.add(time + " cannot be empty");

    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    //CurvedAnimation makes Animations smoother (think curve graph as oppose to linear)
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    //Calls the animation whenever an animation changes - Set state rebuilds
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    databaseUtil.dispose();
  }

  @override
  Widget build(BuildContext context) {
    callRandNumber();
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _goal,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).appBarTheme.color),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red)),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(width: 1)),
                              errorText: this.errorText[i],
                              hintText: "Enter Your Goal"),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 10, 50, 0),
                          child: Container(
                            height: 40,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.access_time),
                                Expanded(
                                  child: CupertinoDatePicker(
                                    minuteInterval: 30,
                                    use24hFormat: true,
                                    initialDateTime: dateTime,
                                    mode: CupertinoDatePickerMode.time,
                                    onDateTimeChanged: (currentTime) {
                                      setState(() {
                                        DateFormat _df = DateFormat.Hm();
                                        this.time = _df.format(currentTime);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                            child: Text(
                              "Book",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              /*
                              print(validateAppointment(
                                      time == null ? "00:00" : time,
                                      "nuthsaid@gmail.com")
                                  .toString());
*/
                              addAppointment(
                                time == null ? "00:00" : time,
                                "nuthsaid@gmail.com",
                                _goal.text,
                              );
                              //Firebase
                            })
                      ],
                    ))),
          ),
        ),
      ),
    );
  }

  /*
  int validateAppointment(String time, String user) {
    Map<dynamic, dynamic> values;
    //Captures DATASET ONCE,
    int end = 3298234;
    databaseUtil
        .getAwaitingApppontmentsData(_database, widget.selectedDate, time)
        .then((DataSnapshot snapshot) {
      values = snapshot.value;
      if (values != null) {
        //Prevent duplicate
        values.forEach((key, values) {
          print(user + values["user"]);
          if (values["user"] == user) {
            print("contains user");
            setState(() {
              this.errorText.add(time + " Invalid time");
              this.i = 2;
            });
            return null;
          }
        });
      }
    });
    return end;
  }
*/

  int callRandNumber() {
    Random rand = Random();
    var num = rand.nextInt(100000);

    return num;
  }

  void addAppointment(String time, String user, String goals) {
    if (goals.isEmpty) {
      setState(() {
        i = 1;
      });
    } else {
      Confirmed confirmedAppointment;
      Awaiting newAppointment;
      Awaiting prexistingAppointment;
      //Used to get the key & Value of our Snapshot
      Map<dynamic, dynamic> values;

      //Reads through database, given the date & time
      databaseUtil
          .getAwaitingApppontmentsData(_database, widget.selectedDate, time)
          .then((DataSnapshot snapshot) {
        newAppointment = Awaiting(user: user, goal: goals, hasMatched: false);
        //Meaning these are the first entry of the day @ that time
        if (snapshot.value == null) {
          //insert
          databaseUtil.insertAppointment(
              _database, widget.selectedDate, time, newAppointment);
        } else {
          values = snapshot.value;
          //Used to insert false value @ the end
          int length = values.length;
          int i = 0;
          values.forEach((key, values) {
            i++;
            //TO DO & gmail not the same
            if (values["hasMatched"] == false) {
              prexistingAppointment = Awaiting(
                  user: values["user"], goal: values["goal"], hasMatched: true);
              print("values is " + values["user"]);
              this.allUsers.add(values["user"].toString());
              //update Given key
              databaseUtil.updateAppointmentGivenKey(_database,
                  widget.selectedDate, time, key, prexistingAppointment);

              newAppointment.hasMatched = true;
              //insert
              databaseUtil.insertAppointment(
                  _database, widget.selectedDate, time, newAppointment);
              allUsers.add(newAppointment.user);

              confirmedAppointment = Confirmed(
                  users: this.allUsers,
                  channelName: callRandNumber(),
                  time: time);
              //Inserts to Confirm
              databaseUtil.insertAppointment(
                  _database2, widget.selectedDate, time, confirmedAppointment);
            } else if (i == length && newAppointment.hasMatched == false) {
              //insert
              databaseUtil.insertAppointment(
                  _database, widget.selectedDate, time, newAppointment);
            }
            allUsers.clear();
          });
        }
      });
    }
  }
}
