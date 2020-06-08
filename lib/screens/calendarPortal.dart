import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_buddy/helpers/debug_helper.dart';
import 'package:study_buddy/model/BaseAuth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:study_buddy/model/calendar/Appointments/awaiting.dart';
import 'package:study_buddy/model/calendar/Appointments/confirmed.dart';
import 'package:study_buddy/model/firebase_database_util.dart';
import 'package:study_buddy/service/timeHelperService.dart';
import 'package:timezone/timezone.dart';

class CalendarPortal extends StatefulWidget {
  final String selectedDate;
  final String user;

  CalendarPortal({this.selectedDate, this.user});
  @override
  _CalendarPortalState createState() => _CalendarPortalState();
}

class _CalendarPortalState extends State<CalendarPortal>
    with SingleTickerProviderStateMixin {
  int _selection = 0;
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

  String user;
  List<String> allUsers = List<String>();
  TextEditingController _goal = TextEditingController();
  List<String> errorText = List<String>();
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
    Auth().getCurrentUser().then((firebaseUser) {
      this.user = firebaseUser.email.toString();
    }).catchError((error) {
      this.user = widget.user;
      //Re login
    });

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
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    //CurvedAnimation makes Animations smoother (think curve graph as oppose to linear)
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInExpo);
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

  Widget _handleSelection() {
    switch (_selection) {
      case 0:
        return intro();
        break;

      case 1:
        return selectTime();
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    TimeHelperService().convertLocalToDetroit();

    return Center(
      child: Material(color: Colors.transparent, child: _handleSelection()),
    );
  }

  Widget intro() {
    return ScaleTransition(
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
                    Text(
                      "Hi, Jason",
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.display1.fontSize),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Do you still reside in Toronto?",
                        style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.display1.fontSize),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0), //adds padding inside the button
                          minWidth: 40, //wraps child's width
                          buttonColor: Theme.of(context).errorColor,
                          child: RaisedButton(
                            child: Text(
                              "No",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              //Send them to settings
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ButtonTheme(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0), //adds padding inside the button
                          minWidth: 100, //wraps child's width
                          buttonColor: Theme.of(context).buttonColor,
                          child: RaisedButton(
                            child: Text(
                              "Yes",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              setState(() {
                                _selection = 1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }

  //Widget select

  Widget selectTime() {
    return ScaleTransition(
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
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                use24hFormat: false,
                                initialDateTime: dateTime,
                                mode: CupertinoDatePickerMode.time,
                                onDateTimeChanged: (currentTime) {
                                  setState(() {
                                    this.time = _df.format(currentTime);

                                    this.selectedTime = currentTime;
                                    this.storeEndTime = currentTime
                                        .add(Duration(hours: numHours));
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
                            if (storeEndTime == null ||
                                selectedTime == null ||
                                time == null) {
                              setState(() {
                                time = "00:00";
                                selectedTime = dateTime;
                                storeEndTime = dateTime.add(Duration(hours: 1));
                              });
                            }
                            setState(() {
                              i = 0;
                            });

                            validateAppointment(user, _goal.text, time);
                          }),
                    )
                  ],
                ))),
      ),
    );
  }

  //Validates appointment by checking for time conflict and matching if both hasMatched are false
  void validateAppointment(String user, String goal, String time) {
    if (goal.isEmpty) {
      setState(() {
        i = 1;
      });
    } else {
      databaseUtil
          .getAwaitingApppointmentsData(_database, widget.selectedDate, time)
          .then((DataSnapshot snapshot) {
        //Check if user exists @ time
        if (snapshot.value.toString().contains(user)) {
          print("the key exists at that location" + snapshot.key);
          setState(() {
            i = 2;
          });

          _database
              .child(widget.selectedDate)
              .child(time)
              .child(snapshot.key)
              .remove();
        } else {
          _database.child(widget.selectedDate).once().then((snapshot) {
            //There is a user somewhere in the database
            if (snapshot.value.toString().contains(user)) {
              List<String> splitTime;

              Map<dynamic, dynamic> value = snapshot.value;
              value.forEach((key, value) {
                //this can be a method on its own

                //Change String into DateTime function,
                splitTime = key.toString().split(":");
                DateTime _dbTime = DateTime(2020, 1, 1, int.parse(splitTime[0]),
                    int.parse(splitTime[1]));

                //dummy time to find the difference
                if (selectedTime.isAfter(_dbTime)) {
                  int diff = selectedTime.difference(_dbTime).inMinutes;
                  if (diff >= 0 && diff <= 60) {
                    print("time after");
                    setState(() {
                      i = 3;
                    });
                    //Might have to re-check this since the print may be misleading
                    print("Incompatible: " + _dbTime.toString());
                  }
                }
                if (selectedTime.isBefore(_dbTime)) {
                  int diff = _dbTime.difference(selectedTime).inMinutes;
                  print(diff);
                  if (diff >= 0 && diff <= 60) {
                    setState(() {
                      i = 3;
                    });
                    print("Incompatible: " + _dbTime.toString());
                  }
                }
              });
            } else {
              setState(() {
                i = 0;
              });
              print("No user anywhere");
            }
            print("I IS " + i.toString());
            if (i == 0) {
              addAppointment(
                time == null ? "00:00" : time,
                _df.format(storeEndTime),
                user,
                _goal.text,
              ).whenComplete(() {
                //  Navigator.of(context).pop();
              });
            }
          });
        }
      });
    }
  }

  int callRandNumber() {
    Random rand = Random();
    var num = rand.nextInt(100000);

    return num;
  }

  Future<void> addAppointment(
      String time, String endTime, String user, String goals) async {
    Confirmed confirmedAppointment;
    Awaiting Appointment;
    Awaiting prexistingAppointment;
    //Used to get the key & Value of our Snapshot
    Map<dynamic, dynamic> values;

    //Reads through database, given the date & time
    await databaseUtil
        .getAwaitingApppointmentsData(_database, widget.selectedDate, time)
        .then((DataSnapshot snapshot) {
      Appointment = Awaiting(
          user: user, goal: goals, hasMatched: false, endTime: endTime);

      //Meaning these are the first entry of the day @ that time
      if (snapshot.value == null) {
        //insert
        databaseUtil.insertAppointment(
            _database, widget.selectedDate, time, Appointment);
        // Navigator.of(context).pop();
      } else {
        values = snapshot.value;

        int length = values.length;
        int j = 0;
        //ErrorText, do not proceed if the user exists @ that specific time

        values.forEach((key, values) {
          j++;

          // print("HII" + values["timeConflicts"].toString());

          //Change previous false value to true, and give the   value to true
          if (values["hasMatched"] == false) {
            prexistingAppointment = Awaiting(
                user: values["user"],
                goal: values["goal"],
                endTime: values["endTime"],
                hasMatched: true);
            this.allUsers.add(values["user"].toString());
            //update Given key
            databaseUtil.updateAppointmentGivenKey(_database,
                widget.selectedDate, time, key, prexistingAppointment);

            Appointment.hasMatched = true;
            //insert
            databaseUtil.insertAppointment(
                _database, widget.selectedDate, time, Appointment);
            allUsers.add(Appointment.user);

            confirmedAppointment = Confirmed(
                users: this.allUsers,
                date: widget.selectedDate,
                channelName: callRandNumber(),
                time: time);
            //Inserts to Confirm
            databaseUtil.insertConfirmation(
                _database2, widget.selectedDate, time, confirmedAppointment);
            //    Navigator.of(context).pop();
          } else if (j == length && Appointment.hasMatched == false) {
            //Get end time

            //insert
            databaseUtil.insertAppointment(
                _database, widget.selectedDate, time, Appointment);
          }
          allUsers.clear();
        });
      }
    });
  }
}
