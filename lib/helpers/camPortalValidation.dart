import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:study_buddy/data/data.dart';
import 'package:study_buddy/helpers/debug_helper.dart';
import 'package:study_buddy/model/firebase_database_util.dart';
import 'package:study_buddy/screens/webcam/Peer2Stranger/cam.dart';

class CamCredentialModel {
  String errorText;
  String endTime;
  String channelName;
  CamCredentialModel({this.errorText, this.endTime, this.channelName});
}

class CamPortalValidation {
  static CamCredentialModel camCredentialModel =
      CamCredentialModel(errorText: " ");

  static List<String> dates = Data.days(7);
  static bool foundTime = false;

  //Validates wether this is the correct appointment

  ///Validates wether this is the correct appointment.
  ///If channel name is set, then it is validated by time, and channel name.
  ///Conversely if channel name is not set, then it is only validated by time.
  static Future<void> isValidateAppointment(
      FirebaseDatabaseUtil databaseUtil, String user, BuildContext context,
      {String channelName = "auto"}) async {
    //Always check for nulls
    if (user == null) {
      return;
    }
    String child1 = 'Peer2Strangers';
    String child2 = 'Appointments';
    String child4 = 'Confirmed';
    //initialize

    DatabaseReference _database2 = FirebaseDatabase.instance.reference();
    _database2 = _database2.child(child1).child(child2).child(child4);
    //TO-DO Check if number corresponds to user(s)
    if (channelName.isEmpty && channelName != "auto") {
      camCredentialModel.errorText = "Text cannot be empty";
    } else {
      //Reads from database
      if (_database2 == null) {
        DebugHelper.green("test!!!");
      }

      await databaseUtil
          .getConfirmationData(_database2)
          .then((DataSnapshot snapshot) async {
        DebugHelper.red(snapshot.value.toString());

        //if it exists anywhere in the snapshot
        if (snapshot.value.toString().contains(user) &&
            snapshot.value.toString().contains(dates[0])) {
          Map<dynamic, dynamic> value = snapshot.value;
          value.forEach((key, value) {
            //Get exact data

            if (value["date"].toString() == dates[0].toString() &&
                value["users"].toString().contains(user)) {
              //Use the string of our startTime, and incremends it by 1 hour
              String startTime = value["time"];
              String endTime = Data.getEndTime(startTime);
              List<String> splitTime = startTime.toString().split(":");
              List<String> splitEndTime = endTime.toString().split(":");

              //At this point we've confirmed the user & the time
              if (isValidTime(splitTime, splitEndTime) == true) {
                //overwriting the errorText due to loop capturing all data
                foundTime = true;
                camCredentialModel.errorText = "";
                camCredentialModel.channelName = channelName;
                camCredentialModel.endTime = endTime;
                if (channelName == "auto") {
                  camCredentialModel.errorText = "success";
                  //toWebcam
                } else {
                  if (channelName != value["channelName"].toString()) {
                    camCredentialModel.errorText =
                        "Please enter these digits " +
                            value["channelName"].toString();
                  } else {
                    //towebcam
                    // toWebcam(endTime, channelName, context);

                    camCredentialModel.errorText = "success";
                  }
                }

                //Entering too late or too early, but means date is found
              } else if (foundTime == false &&
                  isValidTime(splitTime, splitEndTime) == false) {
                DebugHelper.white("Appointment: " +
                    splitTime.toString() +
                    " " +
                    splitEndTime.toString());
                camCredentialModel.errorText = "Entering too early or too late";
              }
            }
          });
        }
        //Does not exist anywhere
        else {
          camCredentialModel.errorText = "Please book, or review your status";
        }
      });
    }
  }

//Uses a default date (month, year, day) as base to find out if time (hh:mm) is valid
  ///Valid time when the user enters 10 minutes earlier, on time,
  ///or before the end of his appointment.
  static bool isValidTime(List<String> splitTime, List<String> splitEndTime) {
    DateTime now =
        DateTime(2020, 1, 1, DateTime.now().hour, DateTime.now().minute);
    DateTime tempEndTime = DateTime(
        2020, 1, 1, int.parse(splitEndTime[0]), int.parse(splitEndTime[1]));
    //Users can enter 10 minutes early
    DateTime tempTime =
        DateTime(2020, 1, 1, int.parse(splitTime[0]), int.parse(splitTime[1]))
            .subtract(Duration(minutes: 10));

    if (now.isAfter(tempTime) && now.isBefore(tempEndTime) ||
        now.isAtSameMomentAs(tempTime)) {
      return true;
    } else {
      return false;
    }
  }

  //DateTime compareTimes(List<String> time, List<String> endTime) {}
  static Future<void> toWebcam(
      CamCredentialModel camCredentialModel, BuildContext context) async {
    //else if incorect . . .
    // errorText = null;
    print(camCredentialModel.channelName);
    //Get permission for Mic and Camera and see if they accepted them
    await _getCameraAndMic();
    //Get current time - by endTime

    List<String> splitEndTime =
        camCredentialModel.endTime.toString().split(":");
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
          channelName: camCredentialModel.channelName,
          duration: duration,
        ),
      ),
    );
  }

  static Future<void> _getCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
