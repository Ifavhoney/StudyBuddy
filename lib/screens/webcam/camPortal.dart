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

  bool isValid = false;

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
                    padding: const EdgeInsets.all(30.0),
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
                              hintText: "Enter Channel Name"),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                            child: Text(
                              "Enter Video Call",
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () => isValidateAppointment(user))
                      ],
                    ))),
          ),
        ),
      ),
    );
  }

  void isValidateAppointment(String user) {
    //TO-DO Check if number corresponds to user(s)
    if (_channelName.text.isEmpty) {
      setState(() {
        errorText = "Text cannot be empty";
      });
    } else {
      databaseUtil
          .getConfirmationData(_database2)
          .then((DataSnapshot snapshot) {
        //if it exists anywhere in the snapshot
        if (snapshot.value.toString().contains(user) &&
            snapshot.value.toString().contains(dates[0])) {
          Map<dynamic, dynamic> value = snapshot.value;
          value.forEach((key, value) {
            if (value["date"].toString() == dates[0].toString() &&
                value["users"].toString().contains(user)) {
              //Turn time & endTime into datetime
              String endTime = Data.getEndTime(value["time"]);
              List<String> splitTime = value["time"].toString().split(":");
              List<String> splitEndTime = endTime.toString().split(":");

              DateTime tempTime = DateTime(
                  2020, 1, 1, int.parse(splitTime[0]), int.parse(splitTime[1]));
              DateTime tempEndTime = DateTime(
                  2020, 1, 1, int.parse(endTime[0]), int.parse(endTime[1]));

              print(dates[0].toString());
              print(tempTime.toString());

              print(tempEndTime.toString());
            } else {
              print(dates[0].toString());
              setState(() {
                errorText = "No appointments today";
              });
            }
          });
        }
        //Does not exist anywhere
        else {
          setState(() {
            errorText = "Please book or wait for a match";
          });
        }
      });
      print(isValid);
    }
  }

  //DateTime compareTimes(List<String> time, List<String> endTime) {}
  Future<void> toWebcam() async {
    //else if incorect . . .
    setState(() {
      errorText = null;
    });
    print(_channelName);
    //Get permission for Mic and Camera and see if they accepted them
    await _getCameraAndMic();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cam(
          channelName: _channelName.text,
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
