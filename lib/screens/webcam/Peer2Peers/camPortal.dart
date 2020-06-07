import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:study_buddy/helpers/camPortalValidation.dart';
import 'package:study_buddy/helpers/debug_helper.dart';
import 'package:study_buddy/model/firebase_database_util.dart';
import 'package:study_buddy/model/BaseAuth.dart';
import 'package:study_buddy/data/data.dart';
import 'dart:async';

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
                            onPressed: () {
                              CamPortalValidation.isValidateAppointment(
                                databaseUtil,
                                user,
                                context,
                                channelName: _channelName.text,
                              );
                              setState(() {
                                errorText = CamPortalValidation
                                    .camCredentialModel.errorText;
                              });
                            }),
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
}
