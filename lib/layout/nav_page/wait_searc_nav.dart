import 'package:animations/animations.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/widgets/static/global_app_bar.dart';
import 'package:buddy/global/widgets/static/global_bottom_navigation_bar.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/chat/widget/chat_add_friend_popup.dart';
import 'package:buddy/layout/friend/controller/friend_ctrl.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

///WaitingView -> Waiting
///Fade Through

class WaitSearNavBloc extends GetxController {
  RxInt _page = 0.obs;
  int get page => _page.value;
  int nextPage() => _page.value += 1;
  int prevPage() => _page.value -= 1;
  int setPage(int value) => _page.value = value;
}

class WaitSearNav extends StatefulWidget {
  const WaitSearNav();

  @override
  _WaitSearNavState createState() {
    return _WaitSearNavState();
  }
}

class _WaitSearNavState extends State<WaitSearNav>
    with TickerProviderStateMixin {
  SharedAxisTransitionType _transitionType = SharedAxisTransitionType.scaled;
  List<Widget> pageList = <Widget>[
    WaitingView(),
    SearchingView(),
  ];
  @override
  Widget build(BuildContext context) {
    //Listener popup if adde
    return GetX<WaitSearNavBloc>(builder: (_) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          floatingActionButton: FloatingActionButton(
              onPressed: () => showModal(
                  context: (Get.context),
                  configuration: FadeScaleTransitionConfiguration(
                      barrierDismissible: true,
                      reverseTransitionDuration: Duration(milliseconds: 10),
                      transitionDuration: Duration(microseconds: 100000)),
                  builder: (context) {
                    return (ChatAddFriendPopup(Global.userConfig.user));
                  })),
          appBar: GlobalAppBar(implyLeading: false, toolbarHeight: 0.00.sh),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageTransitionSwitcher(
                      duration: const Duration(milliseconds: 500),
                      reverse: false,
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                      ) {
                        return SharedAxisTransition(
                            child: child,
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: _transitionType);
                      },
                      child: pageList[_.page]),
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              _.page == 0 ? GlobalBottomNavigationBar() : null);
    });
  }
}
