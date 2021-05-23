import 'dart:async';

import 'package:buddy/global/models/permission_info_model.dart';
import 'package:buddy/global/theme/fonts/fonts.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

///iPhone 8 Plus <= MID >= iPhone X

enum ScreenSize { Small, Mid, Large }

class DeviceConfig extends GetxController {
  bool isIos = GetPlatform.isIOS;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult network;
  PermissionInfoModel permissionInfoModel;
  ScreenSize screenSize;

  //Large
  void init() {
    reset();
    _initPermission();
    _initConnectivity();
    initScreenSize();
    update();
  }

  //Call the APIs only needed
  void _initPermission() async {
    bool allowCamera = await Permission.camera.isGranted;
    bool allowMicrophone = await Permission.camera.isGranted;
    bool allowGallery = await Permission.camera.isGranted;
    bool allowNotifications = await Permission.camera.isGranted;

    permissionInfoModel = PermissionInfoModel(
        allowCamera: allowCamera,
        allowMicrophone: allowMicrophone,
        allowGallery: allowGallery,
        allowNotifications: allowNotifications);
  }

  void _initConnectivity() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result.toString());
      network = result;
      update();
    });
  }

  void initScreenSize() {
    if (Get.context.isPhone) {
      double height = Get.context.height;
      if (height < 736)
        screenSize = ScreenSize.Small;
      else if (height >= 736 && height <= 812)
        screenSize = ScreenSize.Mid;
      else
        screenSize = ScreenSize.Large;
    }
  }

  void updatePermission(PermissionInfoModel permissionInfoModel) {
    this.permissionInfoModel = permissionInfoModel;
    update();
  }

  void reset() {
    _connectivitySubscription?.cancel();
    permissionInfoModel = null;
    screenSize = null;
  }
}
