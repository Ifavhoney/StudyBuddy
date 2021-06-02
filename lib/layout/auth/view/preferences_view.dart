import 'package:animations/animations.dart';
import 'package:buddy/global/widgets/static/global_app_bar.dart';
import 'package:buddy/global/widgets/static/global_trademark_text.dart';
import 'package:buddy/layout/auth/widget/questionaire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///PreferencesView -> 01 -> 02 -> 03...
///Shared Axis

class PrevNav extends GetxController {
  RxInt _page = 0.obs;
  int get page => _page.value;
  int nextPage() => _page.value += 1;
}

class PreferencesView extends StatefulWidget {
  const PreferencesView();

  @override
  _PreferencesViewState createState() {
    return _PreferencesViewState();
  }
}

class _PreferencesViewState extends State<PreferencesView>
    with TickerProviderStateMixin {
  SharedAxisTransitionType _transitionType =
      SharedAxisTransitionType.horizontal;

  @override
  Widget build(BuildContext context) {
    return GetX<PrevNav>(builder: (_) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: GlobalAppBar(implyLeading: false, toolbarHeight: 0.03.sh),
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
                        transitionType: _transitionType,
                      );
                    },
                    child: Questionaire(_.page)),
              ),
            ],
          ),
        ),
        bottomNavigationBar: GlobalTrademarkText(),
      );
    });
  }
}
