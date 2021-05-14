class PermissionInfoModel {
  final bool allowCamera;
  final bool allowMicrophone;
  final bool allowGallery;
  final bool allowNotifications;

  PermissionInfoModel(
      {this.allowCamera = false,
      this.allowMicrophone = false,
      this.allowGallery = false,
      this.allowNotifications = false});
}
