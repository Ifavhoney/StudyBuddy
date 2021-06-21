import 'package:buddy/global/global.dart';
import 'package:buddy/global/helper/time_helper.dart';
import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/global/widgets/static/global_time_helper.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/chat/args/chat_args.dart';
import 'package:buddy/layout/chat/controller/chat_controller.dart';
import 'package:buddy/layout/chat/widget/chat_message.dart';
import 'package:buddy/layout/chat/widget/chat_textfield.dart';
import 'package:buddy/layout/chat/widget/person.dart';
import 'package:buddy/layout/chat/widget/generic_body.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/nav_page/view_spner_chld_nav.dart';
import 'package:buddy/layout/orrin/model/user.dart';
import 'package:buddy/layout/orrin/sharedWidgets/mascotImage.dart';

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
  ChatController _chatController = Get.find<ChatController>();

  final ChatArgs chatArgs = Get.arguments["chatArgs"];

  ScrollController _scrollController = new ScrollController();
  FocusNode _focusNode = FocusNode();
  bool _iskeyboardShowing;

  bool isReady = false;
  Stream<dynamic> _chatStream;
  TimeHelper timeHelper = Get.find<TimeHelper>();

  @override
  void initState() {
    _chatController
        .initState(context, SearchingView.routeName, chatArgs)
        .whenComplete(() {
      setState(() {
        isReady = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timeHelper.users.clear();
    timeHelper.primaryTimer?.cancel();
    timeHelper.secondaryTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _iskeyboardShowing =
        MediaQuery.of(context).viewInsets.bottom > 0 ? true : false;
    // print("is Ready" + isReady.toString());
    return ViewSpnerChldNav(
      isReady: isReady,
      ms: 300,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: GenericBody(
                implyLeading: false,
                backgroundColor: Color(0xFFB9D1FF),
                chatPeople: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //    Padding(padding: EdgeInsets.only(bottom: 0.1.sh)),

                      Transform(
                        transform: Matrix4.translationValues(0, -0.01.sh, 0.0),
                        child: MascotImage(size: 0.07.sh),
                      ),
                      GlobalTimeHelper(
                          margin: EdgeInsets.only(top: 0.01.sh),
                          color: Colors.white,
                          textStyle: Global.appTheme.fonts.sfProText.subtitle1),

                      SizedBox(width: 0.02.sw),
                      //  _chatPeople(),
                    ]),
                isKeyboardShowing: _iskeyboardShowing,
                body: GestureDetector(
                  onDoubleTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0.01.sw, vertical: 0.01.sh),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            child: StreamBuilder(
                                stream: _chatStream,
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
                                            text:
                                                _chatController.list[i].message,
                                          ),
                                          SizedBox(height: 0.02.sh),
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
                                    ScreenUtil().screenHeight / 2,
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
      ),
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
