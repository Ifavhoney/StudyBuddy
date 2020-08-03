import 'package:permission_handler/permission_handler.dart';

class CamController {
  static Future<void> _getCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
}
