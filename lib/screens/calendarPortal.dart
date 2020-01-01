import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:study_buddy/model/calendar/Appointments/awaiting.dart';
import 'package:study_buddy/model/calendar/Appointments/confirmed.dart';
import 'package:study_buddy/model/firebase_database_util.dart';

import 'calendar.dart';

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

  DateTime dateTime;
  DateFormat _df;

  String time;
  String endTime;
  DateTime selectedTime;
  DateTime storeEndTime;

  List<String> _timeConflicts = new List<String>();

  List<String> allUsers = new List<String>();
  TextEditingController _goal = new TextEditingController();
  List<String> errorText = new List<String>();
  int i;
  int numHours;
  int clicked = -1;

  //neccessary to set the duration of our animation
  AnimationController controller;
  //0-1 indicates wether running or completed
  Animation<double> scaleAnimation;

  DatabaseReference _database = FirebaseDatabase.instance.reference();
  DatabaseReference _database2 = FirebaseDatabase.instance.reference();
  @override
  void initState() {
    dateTime = DateTime(2020, 1, 1, 0, 0);
    _df = DateFormat.Hm();

    _database = _database.child(child1).child(child2).child(child3);
    _database2 = _database2.child(child1).child(child2).child(child4);
    databaseUtil = FirebaseDatabaseUtil();
    databaseUtil.initState();

    //databaseUtil.initState();
    numHours = 1;
    i = 0;
    errorText.add("");
    errorText.add("Text cannot be empty");
    errorText.add("You have already selected this specific time");
    errorText.add("Time conflict in your schedule");

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
    controller.dispose();

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
                                        this.time = _df.format(currentTime);

                                        this.selectedTime = currentTime;
                                        this.storeEndTime = currentTime
                                            .add(Duration(hours: numHours));
/*
                                        //Convert to dateFormat
                                        DateTime parsedTime =
                                            DateTime.parse(time);
                                        DateTime parsedEndTime =
                                            DateTime.parse(endTime); 
                                            String amountOfTime = parsedEndTime
                                            .difference(parsedTime)
                                            .toString();
*/
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
                        GestureDetector(
                          child: RaisedButton(
                              child: Text(
                                "Book",
                                style: Theme.of(context).textTheme.button,
                              ),
                              onPressed: () {
                                setState(() {
                                  i = 0;
                                });
                                if (storeEndTime == null ||
                                    selectedTime == null ||
                                    time == null) {
                                  setState(() {
                                    time = "00:00";
                                    selectedTime = dateTime;
                                    storeEndTime =
                                        dateTime.add(Duration(hours: 1));
                                  });
                                }
                                //RESET METHOD FOR VALIDATION
                                String user = "Bab@gmail.com";
                                Awaiting newAppointment = Awaiting(
                                    user: user,
                                    goal: _goal.text,
                                    hasMatched: false,
                                    //    timeConflicts: timeConflicts,
                                    endTime: endTime);

                                if (_goal.text.isEmpty) {
                                  setState(() {
                                    i = 1;
                                  });
                                } else {
                                  if (i == 0) {
                                    addAppointment(
                                      time == null ? "00:00" : time,
                                      _df.format(storeEndTime),
                                      _timeConflicts,
                                      user,
                                      _goal.text,
                                    );
                                  }
                                  databaseUtil
                                      .getAwaitingApppontmentsData(
                                          _database, widget.selectedDate, time)
                                      .then((DataSnapshot snapshot) {
                                    //Check if user exists @ time
                                    if (snapshot.value
                                        .toString()
                                        .contains(user)) {
                                      List<String> splitTime = time.split(":");
                                      dateTime = DateTime(
                                          2020,
                                          1,
                                          1,
                                          int.parse(splitTime[0]),
                                          int.parse(splitTime[1]));

                                      //2
                                      if (storeEndTime.isBefore(selectedTime)) {
                                        setState(() {
                                          i = 3;
                                        });
                                      } else if (selectedTime
                                              .difference(dateTime)
                                              .inMinutes ==
                                          0) {
                                        setState(() {
                                          i = 2;
                                        });
                                        //insert
                                        Map<dynamic, dynamic> value =
                                            snapshot.value;
                                        value.forEach((key, values) {
                                          print(key);
                                          if (values["user"] == user) {
                                            _database
                                                .child(widget.selectedDate)
                                                .child(time)
                                                .child(key)
                                                .remove();
                                          }
                                        });
                                      }
                                    }
                                  });
                                }
                                //Firebase
                              }),
                        )
                      ],
                    ))),
          ),
        ),
      ),
    );
  }

  int callRandNumber() {
    Random rand = Random();
    var num = rand.nextInt(100000);

    return num;
  }

  void addAppointment(String time, String endTime, List<String> timeConflicts,
      String user, String goals) {
    Confirmed confirmedAppointment;
    Awaiting newAppointment;
    Awaiting prexistingAppointment;
    //Used to get the key & Value of our Snapshot
    Map<dynamic, dynamic> values;

    //Reads through database, given the date & time
    databaseUtil
        .getAwaitingApppontmentsData(_database, widget.selectedDate, time)
        .then((DataSnapshot snapshot) {
      newAppointment = Awaiting(
          user: user,
          goal: goals,
          hasMatched: false,
          //    timeConflicts: timeConflicts,
          endTime: endTime);

      //Meaning these are the first entry of the day @ that time
      if (snapshot.value == null) {
        //insert
        databaseUtil.insertAppointment(
            _database, widget.selectedDate, time, newAppointment);
        // Navigator.of(context).pop();
      } else {
        values = snapshot.value;

        int length = values.length;
        int j = 0;
        //ErrorText, do not proceed if the user exists @ that specific time

        values.forEach((key, values) {
          j++;

          // print("HII" + values["timeConflicts"].toString());

          //Change previous false value to true, and give the new value to true
          if (values["hasMatched"] == false) {
            prexistingAppointment = Awaiting(
                user: values["user"],
                goal: values["goal"],
                // timeConflicts: values["timeConflicts"],
                endTime: values["endTime"],
                hasMatched: true);
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
                date: widget.selectedDate,
                channelName: callRandNumber(),
                time: time);
            //Inserts to Confirm
            databaseUtil.insertConfirmation(
                _database2, widget.selectedDate, time, confirmedAppointment);
            //    Navigator.of(context).pop();
          } else if (j == length && newAppointment.hasMatched == false) {
            //Get end time

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
