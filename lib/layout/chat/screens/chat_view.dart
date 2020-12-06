import 'dart:async';

import 'package:buddy/debug/debug_helper.dart';
import 'package:buddy/global/config/config.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/layout/chat/controller/chat_controller.dart';
import 'package:buddy/layout/chat/widget/chat_message.dart';
import 'package:buddy/layout/chat/widget/chat_textfield.dart';
import 'package:buddy/layout/chat/widget/person.dart';
import 'package:buddy/layout/chat/widget/generic_body.dart';
import 'package:buddy/layout/home/view/searching_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Timer _primaryTimer;
  Timer _secondaryTimer;
  int _min = 0;
  int _start = 0;
  @override
  void initState() {
    super.initState();

    _asyncInitState();
    DebugHelper.red("name" + widget.fromView);
    if (widget.fromView == SearchingView.routeName) {
      startPrimaryTimer();

    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _asyncInitState() async {
    await _chatController
        .initState(context, widget.fromView, widget.channel)
        .whenComplete(() {
      setState(() {});
    });
  }

  void startPrimaryTimer() {
    _primaryTimer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      if (_min < 2) {
        _primaryTimer.cancel();
        setState(() {
          _start = 60;
        });
        startSecondaryTimer();
      } else {
        setState(() {
          _min = _min - 1;
        });
      }
    });

    //return new Timer(duration, endTimer);
  }

  void startSecondaryTimer() {
    _secondaryTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_start < 1) {
        _secondaryTimer.cancel();
        //Navigator.of(context).pop();
      } else {
        setState(() {
          _start = _start - 1;
        });
      }
    });

    //return new Timer(duration, endTimer);
  }

  @override
  void dispose() async {
    if (_primaryTimer.isActive == false) {
      _secondaryTimer.cancel();
    }
    if (_primaryTimer.isActive) {
      _primaryTimer.cancel();
    }

    super.dispose();
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
                  _chatText(),
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

  Widget _chatText() => Container(
        margin: EdgeInsets.only(top: 100.h),
        child: Text((_primaryTimer?.isActive == true ? "$_min\m" : "$_start\s"),
            style: AppTheme.sfProText.subtitle1.copyWith(
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.2)),
      );

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
