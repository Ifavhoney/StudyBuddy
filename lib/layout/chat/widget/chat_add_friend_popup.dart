import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/global/global.dart';

import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/layout/nav_page/wait_searc_nav.dart';
import 'package:buddy/layout/orrin/model/user.dart';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatAddFriendPopup extends StatelessWidget {
  final UserModel user;
  ChatAddFriendPopup(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _button(Colors.red, Icon(Icons.thumb_down_alt_sharp), () {
              Get.to(WaitSearNav());
            }),
            SizedBox(width: 0.07.sw),
            _button(Color(0xFFB9D1FF), Icon(Icons.thumb_up_alt_sharp), () {
              
            }),
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 0.1.sh),
            child: GlobalBoxContainer(
                boxShape: BoxShape.rectangle,
                containerColor: Colors.white,
                containerHeight: 0.5.sh,
                containerWidth: 0.8.sw,
                borderRadius: BorderRadius.circular(10.sp),
                boxShadow: BoxShadow(
                    color: Colors.grey, blurRadius: 2, spreadRadius: -2),
                child: Column(
                  children: [
                    SizedBox(height: 0.03.sh),
                    _avatar(this.user.avatar ??
                        "https://firebasestorage.googleapis.com/v0/b/studybuddy-a39ca.appspot.com/o/mascot.png?alt=media&token=a5f866a4-7a46-46b4-8044-a8e558fe08f5"),
                    SizedBox(height: 0.02.sh),
                    AutoSizeText(
                      this.user.fullName ?? " ",
                      style: Global.appTheme.fonts.sfProText.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6d9fff)),
                    ),
                    SizedBox(height: 0.1.sh),
                    _middlepart(this.user.fullName ?? " "),
                  ],
                )),
          ),
        ));
  }

  Widget _avatar(String avatar) {
    return GlobalBoxContainer(
        boxShape: BoxShape.circle,
        boxShadow: BoxShadow(
            color: Color(0xFF707070), blurRadius: 10, spreadRadius: -3),
        child: CircularProfileAvatar(
          avatar,
          errorWidget: (context, url, error) =>
              Container(child: Icon(Icons.error)),
          placeHolder: (context, url) => Container(
              width: 50, height: 50, child: CircularProgressIndicator()),
          radius: 0.07.sh,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: () async {},
          cacheImage: true,
        ));
  }

  Widget _button(Color color, Icon icon, VoidCallback onPressed) {
    return GlobalBoxContainer(
      containerHeight: color == Colors.red ? 0.10.sh : 0.12.sh,
      boxShape: BoxShape.circle,
      boxShadow:
          BoxShadow(color: Color(0xFF707070), blurRadius: 10, spreadRadius: -3),
      child: FittedBox(
        child: FloatingActionButton(
            backgroundColor: color, onPressed: onPressed, child: icon),
      ),
    );
  }

  Widget _middlepart(String nickname) {
    return Column(children: [
      Container(
        width: 0.8.sw,
        alignment: Alignment.center,
        child: AutoSizeText(
          "I would like to be Buddies",
          maxLines: 2,
          style: Global.appTheme.fonts.sfProText.headline6
              .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      SizedBox(height: 0.03.sh),
      Container(
        width: 0.8.sw,
        alignment: Alignment.center,
        child: AutoSizeText(
          "With",
          maxLines: 2,
          style: Global.appTheme.fonts.sfProText.headline6
              .copyWith(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      SizedBox(height: 0.03.sh),
      Container(
        width: 0.8.sw,
        alignment: Alignment.center,
        child: AutoSizeText(
          nickname,
          maxLines: 2,
          style: Global.appTheme.fonts.sfProText.headline6
              .copyWith(fontWeight: FontWeight.bold, color: Color(0xFF6d9fff)),
        ),
      ),
    ]);
  }
}
