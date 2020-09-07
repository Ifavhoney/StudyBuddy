import 'package:buddy/global/config/config.dart';
import 'package:buddy/layout/chat/controller/chat_controller.dart';
import 'package:buddy/layout/chat/models/chat_model.dart';
import 'package:buddy/layout/chat/widget/chat_message.dart';
import 'package:buddy/layout/chat/widget/chat_textfield.dart';
import 'package:buddy/layout/chat/widget/person.dart';
import 'package:buddy/layout/chat/widget/generic_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatView extends StatefulWidget {
  static const String routeName = "/chat_view";

  final int channel;
  final String fromView;

  const ChatView({@required this.fromView, @required this.channel});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController _editingController = TextEditingController();
  ChatController _chatController = new ChatController();

  FocusNode _focusNode = FocusNode();
  bool _iskeyBardShowing;
  @override
  void initState() {
    _asyncInitState();
    super.initState();
  }

  _asyncInitState() async {
    await _chatController.initState(context, widget.fromView, widget.channel);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    _iskeyBardShowing =
        MediaQuery.of(context).viewInsets.bottom != 0 ? true : false;
    return Scaffold(
        body: GenericBody(
            implyLeading: false,
            chatPeople: _chatPeople(),
            isKeyboardShowing: _iskeyBardShowing,
            body: GestureDetector(
              onDoubleTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(children: [
                Container(
                  height: ScreenUtil.screenHeightDp / 1.3,
                  padding: EdgeInsets.all(40.h),
                  child: ListView(
                    children: <Widget>[
                      ChatMessage(
                        isOwn: false,
                        people: Person(),
                        text:
                            "Whether it is Snapchat, Twitter, Facebook, tual characters matters. ",
                      ),
                      SizedBox(height: 40.h),
                      ChatMessage(
                        isOwn: true,
                        people: Person(),
                        text:
                            "Yes i am glad to to see you too, how have you beeddsdsdsddsdsn? I have been good and i dsdsdds ve been a bit like busy but yu knwo i gt !",
                      ),
                      SizedBox(height: 40.h),
                      ChatMessage(
                        isOwn: true,
                        people: Person(),
                        text:
                            "Yes i am glad to to see you too, how have you beeddsdsdsddsdsn? I have been good and i dsdsdds ve been a bit like busy but yu knwo i gt !",
                      ),
                      SizedBox(height: 40.h),
                      ChatMessage(
                        isOwn: false,
                        people: Person(),
                        text:
                            "Whether it is Snapchat, Twitter, Facebook, tual characters matters. ",
                      ),
                      SizedBox(height: 40.h)
                    ],
                  ),
                ),
                ChatTextField(
                  editingController: _editingController,
                  focusNode: _focusNode,
                  heightFactor: 1.3,
                  onSubmitted: (String value) {
                    _chatController.sendMessage(value);
                  },
                )
              ]),
            )));
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
