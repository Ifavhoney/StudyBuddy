import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/chat/widget/generic_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatView extends StatefulWidget {
  static const String routeName = "/chat_view";

  final int channel;
  final String fromView;

  const ChatView({this.fromView, this.channel});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController _editingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  final TextStyle textStyle = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        body: GenericBody(
            implyLeading: false,
            title: "Messages",
            body: Stack(children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(right: ScreenUtil.screenWidthDp / 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: CustomPaint(
                              painter: CustomChatBubble(isOwn: false),
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w, 16.h, 16.w, 16.h),
                                  child: Text(
                                      'Yes Kinda I am glad you are online!',
                                      style: AppTheme.sfProText.bodyText1
                                          .copyWith(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.2))),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        CustomPaint(
                            painter: CustomChatBubble(isOwn: false),
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: FlutterLogo())),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CustomPaint(
                            painter: CustomChatBubble(isOwn: true),
                            child: Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Message from me',
                                  style: TextStyle(color: Colors.white),
                                ))),
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            controller: _editingController,
                            focusNode: _focusNode,
                            minLines: 1,
                            maxLines: 5,
                            maxLength: 150,
                            onSubmitted: (String value) => {},
                            decoration: InputDecoration(
                                fillColor: Color(0xFFd3d3d3).withOpacity(0.2),
                                filled: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(50.w, 25.h, 50.w, 25.h),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100.0),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ))
            ])));
  }
}

class CustomChatBubble extends CustomPainter {
  CustomChatBubble({@required this.isOwn});

  Color color;
  bool isOwn;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color ?? Colors.blue;

    Path paintBubbleTail() {
      Path path;
      if (isOwn) {
        paint.color = Color(0xFF1982FC);
        path = Path()
          ..moveTo(size.width - 6, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height, size.width + 16, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height - 5, size.width, size.height - 17);
      } else {
        paint.color = Color(0xFFd3d3d3).withOpacity(0.5);

        path = Path()
          ..moveTo(5, size.height - 5)
          //little triangle from the left
          ..quadraticBezierTo(-5, size.height, -16, size.height - 4)
          ..quadraticBezierTo(-5, size.height - 5, 0, size.height - 17);
      }

      return path;
    }

    //Use size of the custompainter to adjust text from bubble trail
    final RRect bubbleBody = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(16));

    final Path bubbleTail = paintBubbleTail();

    canvas.drawRRect(bubbleBody, paint);
    canvas.drawPath(bubbleTail, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
/*

*/
