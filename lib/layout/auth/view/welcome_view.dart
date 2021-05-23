import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:buddy/global/global.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:buddy/layout/orrin/sharedWidgets/mascotImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WelcomeView extends StatelessWidget {
  static const routeName = '/welcomeView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _widget());
  }

  Widget _widget() {
    return Container(
      height: ScreenUtil.defaultSize.height,
      width: ScreenUtil.defaultSize.width,
      padding: EdgeInsets.fromLTRB(0, 0.1.sw, 0, 0.05.sw),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            AutoSizeText("Hello Buddy!",
                style: Global.appTheme.fonts.segoeUi.headline2),
            MascotImage(size: 0.5.sh),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Container(
                      child: Row(children: <Widget>[
                        Container(
                          height: 0.055.sh,
                          width: 0.12.sw,
                          child: Icon(
                            FontAwesomeIcons.google,
                            color: Colors.black,
                          ),
                        ),
                        AutoSizeText('Sign in with Google',
                            style: Global.appTheme.fonts.sfProText.headline6
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Global.appTheme.fonts.sfProText
                                            .headline6.fontSize +
                                        2.sp,
                                    color: Colors.black))
                      ]),
                    ),
                    onPressed: () {
                      AuthController().signInWithGoogle().whenComplete(() {
                        Get.offNamed(WaitingView.routeName);
                      });
                    },
                  ),
                ],
              ),
            ),
            // ElevatedButton(
            //   child: Container(
            //       width: 0.7.sw,
            //       decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //           colors: <Color>[
            //             Color(0xFFDDC3EC),
            //             Color(0xFFB9D1FF),
            //           ],
            //         ),
            //         borderRadius: BorderRadius.circular(40.sp),
            //       ),
            //       child: Center(
            //         child: AutoSizeText("Sign in",
            //             style: Global.appTheme.segoeUi.headline5.copyWith()),
            //       ),
            //       padding: EdgeInsets.all(15.sp)),
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
