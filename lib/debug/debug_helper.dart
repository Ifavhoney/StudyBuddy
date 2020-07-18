import 'package:ansicolor/ansicolor.dart';

class DebugHelper {
  static void white(dynamic text) {
    AnsiPen pen = new AnsiPen()..white(bold: true);

    print(pen(text.toString()));
  }

  static void green(dynamic text) {
    AnsiPen pen = new AnsiPen()
      ..green(
        bold: true,
      );
    print(pen(text.toString()));
  }

  static void red(dynamic text) {
    AnsiPen pen = new AnsiPen()..red(bold: true);
    print(pen(text.toString()));
  }
}
