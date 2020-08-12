import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/widgets/animation/global_flashing_circle.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/webcam/controller/cam_controller.dart';
import 'package:buddy/layout/webcam/model/cam_model.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
class SearchingView extends StatefulWidget {
  static const routeName = '/searching_view';
  @override
  _SearchingViewState createState() => _SearchingViewState();
}

class _SearchingViewState extends State<SearchingView> {
  String user;

  FirebaseDatabase database = new FirebaseDatabase();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //insert
    /*
    _ref.push().set(<String, String>{
      "user": "some name",
    }).then((value) => DebugHelper.red("COMPLETE"));
    */

    //UPDATE
    // _ref.child("-MEWxIbDR1L_EGzxVplq").update({"user": "something else"});

    //delete

    return Scaffold(
      body: Stack(children: <Widget>[
        GlobalFlashingCircle(),
        _mascot(),
        /*
        GlobalFallingCircles(
          durationInSeconds: 10,
          heightOfDevice: MediaQuery.of(context).size.height,
          widthOfDevice: MediaQuery.of(context).size.width,
        )
        */
      ]),
      backgroundColor: Colors.white,
    );
  }

  _funct() async {
    await AuthController().getCurrentUser().then((firebaseUser) {
      this.user = firebaseUser.email.toString();
    }).catchError((error) {
      this.user = "dummy@gmail.com";
      //Re login
    });
    DebugHelper.red("user is " + this.user);
  }

  Widget _mascot() => GestureDetector(
        onTap: () => CamController.toWebcam(
            CamModel(channelName: "1", endTime: "09:15"), context),
        child: Center(
          child: Image.asset(
            "assets/images/mascot.png",
            fit: BoxFit.scaleDown,
            height: MediaQuery.of(context).size.height / 14,
          ),
        ),
      );
}
