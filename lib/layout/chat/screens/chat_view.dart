import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/chat/widget/chat_message.dart';
import 'package:buddy/layout/chat/widget/custom_chat_bubble.dart';
import 'package:buddy/layout/chat/widget/person.dart';
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
            chatPeople: _chatPeople(),
            title: "Messages",
            body: Stack(children: [
              Container(
                padding: EdgeInsets.all(40.h),
                child: ListView(
                  children: <Widget>[
                    ChatMessage(
                      isOwn: false,
                      people: Person(),
                      text:
                          "Whether it is Snapchat, Twitter, Facebook, tual characters matters. ",
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
                    ChatMessage(
                      isOwn: true,
                      people: Person(),
                      text:
                          "Yes i am glad to to see you too, how have you beeddsdsdsddsdsn? I have been good and i dsdsdds ve been a bit like busy but yu knwo i gt !",
                    ),
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

  Widget _chatPeople() => Align(
      alignment: Alignment.topRight,
      child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 6,
          child: ListView(
              shrinkWrap: true,
              reverse: true,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[Person()])));
}

/*

*/
