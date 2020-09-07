import 'package:buddy/layout/chat/controller/chat_controller.dart';
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
  ScrollController _scrollController = new ScrollController();

  FocusNode _focusNode = FocusNode();
  bool _iskeyboardShowing;
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
    _iskeyboardShowing =
        MediaQuery.of(context).viewInsets.bottom > 0 ? true : false;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: GenericBody(
            implyLeading: false,
            chatPeople: _chatPeople(),
            isKeyboardShowing: _iskeyboardShowing,
            body: GestureDetector(
              onDoubleTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                padding: EdgeInsets.all(40.h),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        controller: _scrollController,
                        shrinkWrap: true,
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
                                "Wether it is Snapchat, Twitter, Facebook, tual characters matters. ",
                          ),
                          SizedBox(height: 40.h),
                          ChatMessage(
                            isOwn: false,
                            people: Person(),
                            text:
                                "Wether it is Snapchat, Twitter, Facebook, tual characters matters. ",
                          ),
                          SizedBox(height: 40.h),
                          ChatMessage(
                            isOwn: false,
                            people: Person(),
                            text:
                                "Wether it is Snapchat, Twitter, Facebook, tual characters matters. ",
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
                                "last: Wether it is Snapchat, Twitter, Facebook, tual characters matters. ",
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                    ChatTextField(
                      editingController: _editingController,
                      focusNode: _focusNode,
                      onTap: () {
                        setState(() {});
                        //TODO Store KeyboardSize in firestore for exact
                        if (!_iskeyboardShowing) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent +
                                MediaQuery.of(context).size.height / 3,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 200),
                          );
                        }
                      },
                      onSubmitted: (String value) {
                        _chatController.sendMessage(value);
                      },
                    ),
                  ],
                ),
              ),
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
