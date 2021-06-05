import 'package:buddy/global/global.dart';
import 'package:buddy/layout/chat/widget/custom_chat_bubble.dart';
import 'package:buddy/layout/chat/widget/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMessage extends StatelessWidget {
  final bool isOwn;
  final Person people;
  final String text;
  const ChatMessage(
      {@required this.people, @required this.text, @required this.isOwn});

  @override
  Widget build(BuildContext context) {
    return _message();
  }

  Widget _message() {
    if (isOwn) {
      return Container(
        margin: EdgeInsets.only(left: ScreenUtil().screenWidth / 7),
        padding: EdgeInsets.fromLTRB(0.01.sh, 0.h, 0.04.sw, 0.h),
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: CustomPaint(
                  painter: CustomChatBubble(isOwn: true),
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 0.020.sh, horizontal: 0.015.sw),
                      child: Text(text,
                          style: Global.appTheme.fonts.sfProText.bodyText1
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2)))),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(right: ScreenUtil().screenWidth / 7),
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            people,
            Flexible(
              child: CustomPaint(
                painter: CustomChatBubble(isOwn: isOwn),
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 0.020.sh, horizontal: 0.015.sw),
                    child: Text(text,
                        style: Global.appTheme.fonts.sfProText.bodyText1
                            .copyWith(
                                color: Colors.black.withOpacity(0.7),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.2))),
              ),
            )
          ],
        ),
      );
    }
  }
}
