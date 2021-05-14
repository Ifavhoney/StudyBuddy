import 'dart:async';

import 'package:buddy/global/models/permission_info_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

///Platform
///Screen Size
///Permission
///Network

class DeviceConfig extends GetxController {
  GetPlatform platform = GetPlatform();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult network;
  PermissionInfoModel permissionInfoModel;



  //Large
  void init() {
    _initPermission();
    _initConnectivity();
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
      network = result;
      update();
    });
  }

  void updatePermission(PermissionInfoModel permissionInfoModel) {
    this.permissionInfoModel = permissionInfoModel;
    update();
  }

  void reset() {
    _connectivitySubscription?.cancel();
    permissionInfoModel = null;
    platform = null;
  }

  /*
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';

  void init() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }

  // Platform messages are asynchronous, so we initialize in an async method.


  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }
  */
}
