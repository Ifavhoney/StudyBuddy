import 'package:buddy/global/theme/theme.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/global/widgets/static/global_bottom_navigation_bar.dart';
import 'package:buddy/layout/home/view/searching_view.dart';
import 'package:flutter/material.dart';

///@LastModifiedBy: Jason NGuessan
class WaitingView extends StatefulWidget {
  static const routeName = '/waiting_view';

  @override
  _WaitingViewState createState() => _WaitingViewState();
}

class _WaitingViewState extends State<WaitingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
          _searchBackround(),
          _search(),
          /*
          GlobalFallingCircles(
            durationInSeconds: 10,
            heightOfDevice: MediaQuery.of(context).size.height,
            widthOfDevice: MediaQuery.of(context).size.width,
          )
          */
        ]),
        backgroundColor: Colors.white,
        bottomNavigationBar: GlobalBottomNavigationBar());
  }

  Widget _search() => GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(SearchingView.routeName),
        child: Center(
          child: GlobalBoxContainer(
            boxShape: BoxShape.circle,
            boxShadow: BoxShadow(
                color: Color(0xFF737BCE), blurRadius: 8, spreadRadius: -2),
            child: Padding(
              padding: const EdgeInsets.all(23.0),
              child: Icon(
                Icons.search,
                size: 45,
                color: AppTheme.searchingViewIcons["search"].withOpacity(0.8),
              ),
            ),
          ),
        ),
      );

  Widget _searchBackround() => Positioned.fill(
        right: 2,
        top: 2,
        child: Center(
          child: Transform.rotate(
            angle: 205,
            child: Container(
              padding: EdgeInsets.all(75),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Color(0xFFDDC3EC),
                    Color(0xFFB9D1FF),
                  ])),
              child: Text("  "),
            ),
          ),
        ),
      );
}
