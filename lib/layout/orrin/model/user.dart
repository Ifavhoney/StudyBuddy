import 'package:buddy/layout/auth/controller/auth_controller.dart';

class UserModel {
  final String fullName;
  final AuthType authType;
  final String email;
  final String platform;
  final String avatar;
  final String country;
  final bool completedProfile;
  final Map<String, dynamic> questionaire;

  UserModel(
      {this.fullName,
      this.authType,
      this.email,
      this.platform,
      this.avatar,
      this.country,
      this.completedProfile,
      this.questionaire});

  UserModel.fromJson(String email, dynamic value)
      : this.fullName = value["fullName"],
        this.email = email,
        this.avatar = value["avatar"],
        this.platform = value["platform"],
        this.country = value["country"],
        this.completedProfile = value["completedProfile"],
        this.authType = _getAuthType(value["authType"]),
        this.questionaire = value["questionaire"];

  static AuthType _getAuthType(String authType) {
    if (authType == "Google")
      return AuthType.Google;
    else
      return AuthType.Apple;
  }
}
