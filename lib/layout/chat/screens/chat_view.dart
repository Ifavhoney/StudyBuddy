import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/helper/date_helper.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/global/widgets/static/global_time_helper.dart';
import 'package:buddy/layout/chat/controller/chat_controller.dart';
import 'package:buddy/layout/chat/widget/chat_message.dart';
import 'package:buddy/layout/chat/widget/chat_textfield.dart';
import 'package:buddy/layout/chat/widget/person.dart';
import 'package:buddy/layout/chat/widget/generic_body.dart';
import 'package:buddy/layout/home/view/searching_view.dart';

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
    super.initState();

    _asyncInitState();
  }

  _asyncInitState() async {
    await _chatController
        .initState(context, widget.fromView, widget.channel)
        .whenComplete(() {
      setState(() {});
    });
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
            chatPeople: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GlobalTimeHelper(
                      margin: EdgeInsets.only(top: 100.h),
                      color: Colors.white,
                      timerInMs:
                          DateHelper.getRemainingTimeFromNowTS(1607267214698)
                              .millisecond,
                      textStyle: AppTheme.sfProText.subtitle1),
                  //  _chatPeople(),
                ]),
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
                        child: StreamBuilder(
                            stream: _chatController
                                .getReference(widget.fromView)
                                .onValue,
                            initialData: [],
                            builder: (ctx, snapshot) => ListView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemCount: _chatController.list.length,
                                itemBuilder: (context, i) => Column(
                                      children: <Widget>[
                                        ChatMessage(
                                          isOwn: Config.user.email ==
                                              _chatController.list[i].email,
                                          people: Person(),
                                          text: _chatController.list[i].message,
                                        ),
                                        SizedBox(height: 40.h),
                                      ],
                                    )))),
                    ChatTextField(
                      editingController: _editingController,
                      focusNode: _focusNode,
                      onTap: () {
                        //TODO Store KeyboardSize in firestore for exact
                        if (!_iskeyboardShowing &&
                            _scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent +
                                ScreenUtil.screenHeightDp / 2,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 200),
                          );
                        }
                        setState(() {});
                      },
                      onSubmitted: (String value) async {
                        await _chatController.sendMessage(
                            value, widget.fromView);
                        _editingController.clear();
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
