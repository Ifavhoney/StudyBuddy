import 'package:buddy/global/theme/theme.dart';
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
    ScreenUtil.init(context);
    return _message();
  }

  Widget _message() {
    if (isOwn) {
      return Container(
        margin: EdgeInsets.only(left: ScreenUtil.screenWidthDp / 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: CustomPaint(
                  painter: CustomChatBubble(isOwn: true),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      child: Text(text,
                          style: AppTheme.sfProText.bodyText1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2)))),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(right: ScreenUtil.screenWidthDp / 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Person(),
            Flexible(
              child: CustomPaint(
                painter: CustomChatBubble(isOwn: isOwn),
                child: Container(
                    padding: EdgeInsets.fromLTRB(30.w, 40.h, 20.w, 40.h),
                    child: Text(text,
                        style: AppTheme.sfProText.bodyText1.copyWith(
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
