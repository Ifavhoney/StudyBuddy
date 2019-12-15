import 'package:flutter/material.dart';

class Data {
  static String _option1 = "School";
  static Icon _icon1 = Icon(Icons.school);
  static String _option2 = "Career";
  static Icon _icon2 = Icon(Icons.work);
  static String _option3 = "Fitness";
  static Icon _icon3 = Icon(Icons.fitness_center);

  static String _option4 = "Chores";
  static Icon _icon4 = Icon(Icons.list);

  static String _option5 = "N/A";
  static List<DropdownMenuItem> items = [
    DropdownMenuItem(
        value: _option1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _icon1,
            Text(_option1),
          ],
        )),
    DropdownMenuItem(
      value: _option2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon2,
          Text(
            _option2,
          ),
        ],
      ),
    ),
    DropdownMenuItem(
      value: _option3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon3,
          Text(
            _option3,
          ),
        ],
      ),
    ),
    DropdownMenuItem(
      value: _option4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon4,
          Text(
            _option4,
          ),
        ],
      ),
    ),
    DropdownMenuItem(
      value: _option5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            _option5,
          ),
        ],
      ),
    ),
  ];
}
