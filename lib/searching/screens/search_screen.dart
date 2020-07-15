import 'package:buddy/global/widgets/global_navigation_bar.dart';
import 'package:buddy/theme/colors/icon_colors.dart';
import 'package:buddy/theme/theme.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Widget> _children = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mic,
              size: 100,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: GlobalNavigationBar());
  }

  Widget item(Icon icon) {}
  Widget search(Icon icon) {}
}
