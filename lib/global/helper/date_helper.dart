import 'package:intl/intl.dart';

class DateHelper {
  ///Gets Datetime.now() in yyyy-MM-dd string format
  static String currentDayInString() =>
      DateFormat("yyyy-MM-dd").format(DateTime.now());

  ///Gets a list of days from now + int of days
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

  ///Gets endTime by increasing the current time by one hour
  static String getEndTimeByOneHour(String time) {
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

  ///Gets the total minutes from now
  static int getTotalMinutesFromNow(List<String> splitEndTime) {
    Duration endTime = Duration(
        hours: int.parse(splitEndTime[0]), minutes: int.parse(splitEndTime[1]));

    Duration curTime =
        Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute);
    return endTime.inMinutes - curTime.inMinutes;
  }

  //Uses a default date (month, year, day) as base to find out if time (hh:mm) is valid
  ///Valid time when the user enters 10 minutes earlier, on time,
  ///or before the end of his appointment.
  static bool isValidTime(List<String> splitTime, List<String> splitEndTime) {
    DateTime now =
        DateTime(2020, 1, 1, DateTime.now().hour, DateTime.now().minute);
    DateTime tempEndTime = DateTime(
        2020, 1, 1, int.parse(splitEndTime[0]), int.parse(splitEndTime[1]));
    //Users can enter 10 minutes early
    DateTime tempTime =
        DateTime(2020, 1, 1, int.parse(splitTime[0]), int.parse(splitTime[1]))
            .subtract(Duration(minutes: 10));

    if (now.isAfter(tempTime) && now.isBefore(tempEndTime) ||
        now.isAtSameMomentAs(tempTime)) {
      return true;
    } else {
      return false;
    }
  }
}
