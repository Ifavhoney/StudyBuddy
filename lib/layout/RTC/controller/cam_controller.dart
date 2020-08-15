import 'package:buddy/global/helper/date_helper.dart';
import 'package:buddy/layout/rtc/model/cam_model.dart';
import 'package:buddy/layout/rtc/view/cam_view.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CamController {
  static List<String> dates = DateHelper.days(7);
  static bool foundTime = false;

  static Future<void> toWebcam(
      CamModel camModel,
    BuildContext context,
  ) async {
    //else if incorect . . .
    // errorText = null;
    print(camModel.channelName);
    //Get permission for Mic and Camera and see if they accepted them
    await _getCameraAndMic();

    List<String> splitEndTime = camModel.endTime.toString().split(":");

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CamView(
          channelName: camModel.channelName,
          duration: DateHelper.getTotalMinutesFromNow(splitEndTime),
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
