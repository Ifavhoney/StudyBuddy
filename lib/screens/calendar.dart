import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:study_buddy/helpers/debug_helper.dart';
import 'package:study_buddy/screens/AddFriends/Navigation.dart';
import 'package:study_buddy/screens/webcam/Peer2Stranger/cam.dart';

import 'login.dart';
import 'webcam/camPortal.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'calendarPortal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:study_buddy/model/firebase_database_util.dart';
import 'calendarStatus.dart';
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
  DatabaseReference _database1 = FirebaseDatabase.instance.reference();

  List<String> dates = [];
  String user;
  bool hasNotBooked = false;

  TextEditingController channelName = new TextEditingController();
  String initialText;
  String errorText;
  String hintText = "Enter Channel Name";
  String buttonText;
  bool disableButton;

  FirebaseDatabaseUtil databaseUtil;
  @override
  void initState() {
    disableButton = true;
    super.initState();
    initialText = "Double tab to book";
    int i = 0;
    now = DateTime.now();
    dates.add(dateFormat.format(now).toString());
    //should be a method in data
    while (i != week) {
      dates.add(dateFormat.format(now.add(Duration(days: i + 1))).toString());
      i += 1;
    }

    Auth().getCurrentUser().then((firebaseUser) {
      this.user = firebaseUser.email.toString();
    }).catchError((error) {
      this.user = "dummy@gmail.com";
      //Re login
    });

    databaseUtil = new FirebaseDatabaseUtil();
    databaseUtil.initState();
    _database1 = _database1.child(child1).child(child2).child(child3);

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
    DebugHelper.green(user);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          leading: Container(),
          title: Text("Calendar"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.time_to_leave),
              onPressed: (){
                Auth().signOut();
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => Login());
                Navigator.of(context).pop(route);
              },

            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: (){
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => NavigationPage());
                Navigator.of(context).push(route);
              },

            ),
            IconButton(
              icon: Icon(Icons.videocam),
              onPressed: () {
                //Does something
                showDialog(
                  context: context,
                  builder: (_) => CamPortal(user),
                );
              },
            ), 
          ],
        ),
        floatingActionButton: RaisedButton(
          child: Text(
            "View Status",
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            MaterialPageRoute route = MaterialPageRoute(builder: (context) {
              return CalendarStatus(user);
            });
            Navigator.of(context).push(route);
          },
        ),
        //Displays 7 snapshots of the awaiting table, and thus showing 7 cards
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 18, 0, 30),
          child: FirebaseAnimatedList(
              query: _database1.orderByKey().limitToFirst(7).startAt(dates[0]),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int i) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[showCard(snapshot, i)],
                  ),
                );
              }),
        ));
  }

  Widget showCard(DataSnapshot dateSnapshot, int i) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 30, 50, 20),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 10,
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          child: Card(
            color: Colors.teal.shade200,
            child: InkWell(
              //Link the correct date to the calendar portal using Snapshot.key
              onDoubleTap: () {
                showDialog(
                    context: this.context,
                    builder: (context) => CalendarPortal(
                          selectedDate: dateSnapshot.key,
                          user: this.user,
                        ));
              },
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  ListTile(
                    title: Text(
                      dateSnapshot.key,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    leading: Icon(Icons.calendar_today),
                    trailing: Icon(
                      Icons.touch_app,
                      color: Colors.teal.shade100,
                      size: 30,
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          initialText,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),

                  Flexible(
                    child: FirebaseAnimatedList(
                        primary: true,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: false,
                        query: _database2.orderByKey(),
                        itemBuilder: (BuildContext context, DataSnapshot res,
                            Animation<double> animation, int i) {
                          //res.key is the random generated key
                          return FutureBuilder<DataSnapshot>(
                            future: _database2.child(res.key).once(),
                            builder: (BuildContext context, snapshot) {
                              String channel;
                              String date;
                              String time;
                              List<dynamic> users;

                              //-----

                              //Can be improved using a method
                              if (snapshot.hasData) {
                                //shows where the user has an apppointment
                                if (snapshot.data.value["users"]
                                        .toString()
                                        .contains(user) &&
                                    dateSnapshot.key ==
                                        snapshot.data.value["date"]) {
                                  channel = snapshot.data.value["channelName"]
                                      .toString();
                                  date = snapshot.data.value["date"];
                                  time = snapshot.data.value["time"];
                                  users = snapshot.data.value["users"];
                                }
                                //Shows where the user does not have an appointment

                                else if (!snapshot.data.value["users"]
                                    .toString()
                                    .contains(user)) {}
                              }
                              return time != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                              colorBrightness: Brightness.dark,
                                              color: Theme.of(context)
                                                  .buttonColor
                                                  .withBlue(255),
                                              onPressed: () {},
                                              child: Text(time)),
                                        )
                                      ],
                                    )
                                  : Text("");
                            },
                          );
                        }),
                  )
                  //Display correct content
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

/*


//Validates wether this is the correct appointment
  void isValidateAppointment(String user) {
    //TO-DO Check if number corresponds to user(s)
    if (_channelName.text.isEmpty) {
      setState(() {
        errorText = "Text cannot be empty";
      });
    } else {
      //Reads from database
      databaseUtil
          .getConfirmationData(_database2)
          .then((DataSnapshot snapshot) {
        //if it exists anywhere in the snapshot
        if (snapshot.value.toString().contains(user) &&
            snapshot.value.toString().contains(dates[0])) {
          Map<dynamic, dynamic> value = snapshot.value;
          bool foundTime = false;
          value.forEach((key, value) {
            //Get exact data
            if (value["date"].toString() == dates[0].toString() &&
                value["users"].toString().contains(user)) {
              //Use the string of our startTime, and incremends it by 1 hour
              String startTime = value["time"];
              String endTime = Data.getEndTime(startTime);
              List<String> splitTime = startTime.toString().split(":");
              List<String> splitEndTime = endTime.toString().split(":");
              //CHANGEEEEEE
              DateTime now = DateTime(
                  2020, 1, 1, DateTime.now().hour, DateTime.now().minute);
              //At this point we've confirmed the user & the time
              if (isValidTime(now, splitTime, splitEndTime) == true) {
                setState(() {
                  //overwriting the errorText due to loop capturing all data
                  foundTime = true;
                  errorText = "";
                });

                if (_channelName.text != value["channelName"].toString()) {
                  setState(() {
                    this.hintText = value["channelName"].toString();
                    errorText = "Please enter these digits";
                    this._channelName.text = "";
                  });
                } else {
                  setState(() {
                    this.errorText = "success";
                  });
                  toWebcam(endTime);
                }

                //Entering too late or too early, but means date is found
              } else if (foundTime == false &&
                  isValidTime(now, splitTime, splitEndTime) == false) {
                print(now.toString() +
                    " " +
                    splitTime.toString() +
                    " " +
                    splitEndTime.toString());
                setState(() {
                  errorText = "Entering too early or too late";
                });
              }
            }
          });
        }
        //Does not exist anywhere 80413
        else {
          setState(() {
            errorText = "Please book, or review your status";
          });
        }
      });
    }
  }
  
//Uses a default date (month, year, day) as base to find out if time (hh:mm) is valid
  bool isValidTime(
      DateTime now, List<String> splitTime, List<String> splitEndTime) {
    DateTime tempTime =
        DateTime(2020, 1, 1, int.parse(splitTime[0]), int.parse(splitTime[1]))
            .subtract(Duration(minutes: 10));
    DateTime tempEndTime = DateTime(
        2020, 1, 1, int.parse(splitEndTime[0]), int.parse(splitEndTime[1]));

    if (now.isAfter(tempTime) && now.isBefore(tempEndTime) ||
        now.isAtSameMomentAs(tempTime)) {
      return true;
    } else {
      return false;
    }
  }
   //DateTime compareTimes(List<String> time, List<String> endTime) {}
  Future<void> toWebcam(String endTime) async {
    //else if incorect . . .
    setState(() {
      errorText = null;
    });
    print(_channelName);
    //Get permission for Mic and Camera and see if they accepted them
    await _getCameraAndMic();
    //Get current time - by endTime

    List<String> splitEndTime = endTime.toString().split(":");
    //e.g 9:30 -  8:30  = duration of 1 hour
    int hour = int.parse(splitEndTime[0]) - DateTime.now().hour;
    int min = int.parse(splitEndTime[1]) - DateTime.now().minute;
    Duration duration = Duration(hours: hour.abs(), minutes: min.abs());
    // Duration duration = Duration(seconds: 15);

    DebugHelper.green(duration.inHours);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cam(
          channelName: _channelName.text,
          duration: duration,
        ),
      ),
    );
  }

  Future<void> _getCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
  */
}
