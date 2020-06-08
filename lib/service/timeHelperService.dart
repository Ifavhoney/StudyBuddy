import 'package:timezone/timezone.dart';
import 'package:flutter/services.dart';

class TimeHelperService {
  TimeHelperService() {
    setup();
  }
  void setup() async {
    var byteData = await rootBundle.load('packages/timezone/data/2020a.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  void convertLocalToDetroit() async {
    DateTime indiaTime = DateTime.now();
    final detroitTime =
        new TZDateTime.from(indiaTime, getLocation('America/Toronto'));
    print('Local India Time: ' + indiaTime.toString());
    print('Detroit Time: ' + detroitTime.toString());
  }
}
