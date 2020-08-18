import 'package:buddy/layout/chat/widget/generic_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Chat extends StatefulWidget {
  static String route = "/Chat";

  @override
  _EmployeeLoginState createState() => _EmployeeLoginState();
}

class _EmployeeLoginState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    print("here");
    return Scaffold(
        body: GenericBody(
      title: "Messages",
    ));
  }
}
