import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'Peer2Peer/cam.dart';

///Cam Portal
class CamPortal extends StatefulWidget {
  @override
  _CamPortalState createState() => _CamPortalState();
}

class _CamPortalState extends State<CamPortal>
    with SingleTickerProviderStateMixin {
  TextEditingController _channelName = new TextEditingController();
  String errorText;
  //neccessary to set the duration of our animation
  AnimationController controller;
  //0-1 indicates wether running or completed
  Animation<double> scaleAnimation;

  @override
  void initState() {
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
                            onPressed: toWebcam)
                      ],
                    ))),
          ),
        ),
      ),
    );
  }

  Future<void> toWebcam() async {
    //TO-DO Check if number corresponds to user(s)
    if (_channelName.text.isEmpty) {
      setState(() {
        errorText = "Text cannot be empty";
      });
    }
    //else if incorect . . .
    else {
      setState(() {
        errorText = null;
      });
      print(_channelName);
      //Get permission for Mic and Camera
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
  }

  Future<void> _getCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
