import 'package:animations/animations.dart';
import 'package:buddy/global/widgets/static/global_app_bar.dart';
import 'package:buddy/global/widgets/static/global_bottom_navigation_bar.dart';
import 'package:buddy/global/widgets/static/global_trademark_text.dart';
import 'package:buddy/layout/chat/screens/chat_view.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:buddy/layout/home/view/waiting_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

///Welcome -> Waiting
///Fade Through

class WaitSearChtNavBloc extends GetxController {
  RxInt _page = 0.obs;
  int get page => _page.value;
  int nextPage() => _page.value += 1;
  int prevPage() => _page.value -= 1;
}

class WaitSearChtNav extends StatefulWidget {
  const WaitSearChtNav();

  @override
  _WaitSearChtNavState createState() {
    return _WaitSearChtNavState();
  }
}

class _WaitSearChtNavState extends State<WaitSearChtNav>
    with TickerProviderStateMixin {
  SharedAxisTransitionType _transitionType = SharedAxisTransitionType.scaled;

  List<Widget> pageList = <Widget>[
    WaitingView(),
    SearchingView(),
    ChatView(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetX<WaitSearChtNavBloc>(builder: (_) {
      return Scaffold(
          resizeToAvoidBottomInset: true,
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
