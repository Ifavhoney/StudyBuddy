import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:study_buddy/model/firebase_database_util.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'package:study_buddy/data/data.dart';
import 'dart:async';
import 'Peer2Stranger/cam.dart';

///Cam Portal
class CamPortal extends StatefulWidget {
  final String user;
  CamPortal(this.user);
  @override
  _CamPortalState createState() => _CamPortalState();
}

class _CamPortalState extends State<CamPortal>
    with SingleTickerProviderStateMixin {
  String child1 = 'Peer2Strangers';
  String child2 = 'Appointments';
  String child4 = 'Confirmed';
  List<String> dates;

  // instance of util class
  FirebaseDatabaseUtil databaseUtil;
  DatabaseReference _database2 = FirebaseDatabase.instance.reference();
  String user;

  TextEditingController _channelName = new TextEditingController();
  String errorText;
  //Using this to display
  String hintText;
  //neccessary to set the duration of our animation
  AnimationController controller;
  //0-1 indicates wether running or completed
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _database2 = _database2.child(child1).child(child2).child(child4);
    dates = Data.days(7);
    databaseUtil = FirebaseDatabaseUtil();
    databaseUtil.initState();
    Auth().getCurrentUser().then((firebaseUser) {
      this.user = firebaseUser.email.toString();
    }).catchError((error) {
      this.user = widget.user;
      //Re login
    });

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
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _channelName,
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
                              errorText: this.errorText,
                              hintText: this.hintText == null
                                  ? "Enter Channel Name"
                                  : this.hintText),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                            child: Text(
                              "Enter Video Call",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () => isValidateAppointment(user)),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Opened 10 minute\nprior appointment",
                            style: TextStyle(
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ))),
          ),
        ),
      ),
    );
  }

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
    int hour = int.parse(splitEndTime[0]) - DateTime.now().hour;
    int min = int.parse(splitEndTime[1]) - DateTime.now().minute;
    Duration duration = Duration(hours: hour.abs(), minutes: min.abs());

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
}
