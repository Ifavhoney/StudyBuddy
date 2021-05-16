import 'package:buddy/global/global.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/global/widgets/static/global_time_helper.dart';
import 'package:buddy/layout/chat/args/chat_args.dart';
import 'package:buddy/layout/chat/controller/chat_controller.dart';
import 'package:buddy/layout/chat/widget/chat_message.dart';
import 'package:buddy/layout/chat/widget/chat_textfield.dart';
import 'package:buddy/layout/chat/widget/person.dart';
import 'package:buddy/layout/chat/widget/generic_body.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatView extends StatefulWidget {
  static const String routeName = "/chat_view";

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController _editingController = TextEditingController();
  ChatController _chatController = new ChatController();

  final ChatArgs chatArgs = Get.arguments["chatArgs"];

  ScrollController _scrollController = new ScrollController();
  FocusNode _focusNode = FocusNode();
  bool _iskeyboardShowing;

  TimeHelper timeHelper = Get.find<TimeHelper>();
  @override
  void initState() {
    super.initState();

    _asyncInitState();
  }

  _asyncInitState() async {
    timeHelper.initAsync(chatArgs.timerInMs, context);
    await _chatController
        .initState(context, chatArgs.fromView, chatArgs.channel, chatArgs.fbKey)
        .whenComplete(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timeHelper.primaryTimer?.cancel();
    timeHelper.secondaryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    _iskeyboardShowing =
        MediaQuery.of(context).viewInsets.bottom > 0 ? true : false;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
                        textStyle: AppTheme().sfProText.subtitle1),
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
                                  .getReference(chatArgs.fromView)
                                  .onValue,
                              initialData: [],
                              builder: (ctx, snapshot) => ListView.builder(
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  itemCount: _chatController.list.length,
                                  itemBuilder: (context, i) {
                                    return Column(
                                      children: <Widget>[
                                        ChatMessage(
                                          isOwn: Global.email ==
                                              _chatController.list[i].email,
                                          people: Person(),
                                          text: _chatController.list[i].message,
                                        ),
                                        SizedBox(height: 40.h),
                                      ],
                                    );
                                  }))),
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
                              value, chatArgs.fromView);
                          _editingController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  /*
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
              */
}
