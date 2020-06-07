import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Data {
  /*Webcam ID */
  static const APP_ID = '2b4ad9fd02844f8f872f8681290dae39';

/*Begin Register.dart */
  static List<DropdownMenuItem> items() {
    String _option1 = "School";
    Icon _icon1 = Icon(Icons.school);
    String _option2 = "Career";
    Icon _icon2 = Icon(Icons.work);
    String _option3 = "Fitness";
    Icon _icon3 = Icon(Icons.fitness_center);

    String _option4 = "Chores";
    Icon _icon4 = Icon(Icons.list);

    String _option5 = "N/A";

    List<DropdownMenuItem> results = [
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
    return results;
  }

  //Formatting date to make it easier to iterate through firebase list
  static List<String> days(int day) {
    int y = 0;
    DateTime now = DateTime.now();

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    List<String> dates = [];
    dates.add(dateFormat.format(now));
    while (y != day) {
      dates.add(dateFormat.format(now.add(Duration(days: y + 1))).toString());
      y += 1;
    }
    //Example: 2020-06-05
    return dates;
  }

  //Gets endTime by increasing the current time by one hour
  static String getEndTime(String time) {
    List<String> splitTime;
    String endTime;
    splitTime = time.toString().split(":");

    int byOneHour = int.parse(splitTime[0]) + 1;
    //Incrementing starts here
    if (splitTime[0].startsWith("0")) {
      splitTime[0] = "0" + byOneHour.toString();
      endTime = splitTime[0] + ":" + splitTime[1];
    } else {
      splitTime[0] = byOneHour.toString();
      endTime = splitTime[0] + ":" + splitTime[1];
    }
    return endTime;
  }

  static int getTotalMinutesFromNow(List<String> splitEndTime) {
    Duration endTime = Duration(
        hours: int.parse(splitEndTime[0]), minutes: int.parse(splitEndTime[1]));

    Duration curTime =
        Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute);
    return endTime.inMinutes - curTime.inMinutes;
  }
}
