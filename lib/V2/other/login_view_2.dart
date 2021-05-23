import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//FOR POPUP
class LoginView2 extends StatelessWidget {
  static const routeName = '/login_view';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      backgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0.sp))),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.

          return GlobalBoxContainer(
              boxShape: BoxShape.rectangle,
              containerColor: Colors.white,
              containerHeight: 0.12.sh,
              containerWidth: 0.8.sw,
              padding:
                  EdgeInsets.symmetric(horizontal: 0.03.sw, vertical: 0.03.sh),
              borderRadius: BorderRadius.circular(10.sp),
              boxShadow: BoxShadow(
                  color: Colors.grey, blurRadius: 2, spreadRadius: -2),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        AuthController().signInWithGoogle().whenComplete(() {
                          Navigator.of(context)
                              .pushNamed(WaitingView.routeName);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.sp),
                            border: Border.all(color: Colors.black)),
                        child: Row(children: <Widget>[
                          Container(
                            height: 0.055.sh,
                            width: 0.12.sw,
                            child: Icon(FontAwesomeIcons.google),
                          ),
                          AutoSizeText('Sign in with Google',
                              style: Global.appTheme.fonts.sfProText.bodyText1
                                  .copyWith(fontWeight: FontWeight.bold))
                        ]),
                      )),
                ],
              ));

          /*
           Container(
              height: 0.5.sw,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  color: Colors.black),
              child: InkWell(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[



                      Container(
                        height: 30.0,
                        width: 30.0,
                        child: Icon(FontAwesomeIcons.google),
                      ),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ]),
              ));
              */
        },
      ),
    );
  }
}

/*
  AuthController().signInWithGoogle().whenComplete(() {
              Navigator.of(context).pushNamed(WaitingView.routeName);
            }),
*/
