import 'package:flutter/material.dart';

class CustomChatBubble extends CustomPainter {
  CustomChatBubble({@required this.isOwn});

  Color color;
  bool isOwn;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color ?? Colors.blue;

    Path paintBubbleTail() {
      Path path;
      if (isOwn) {
        paint.color = Color(0xFF1982FC);
        path = Path()
          ..moveTo(size.width - 6, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height, size.width + 16, size.height - 4)
          ..quadraticBezierTo(
              size.width + 5, size.height - 5, size.width, size.height - 17);
      } else {
        paint.color = Color(0xFFd3d3d3).withOpacity(0.5);

        path = Path()
          ..moveTo(5, size.height - 5)
          //little triangle from the left
          ..quadraticBezierTo(-5, size.height, -16, size.height - 4)
          ..quadraticBezierTo(-5, size.height - 5, 0, size.height - 17);
      }

      return path;
    }

    //Use size of the custompainter to adjust text from bubble trail
    final RRect bubbleBody = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(16));

    final Path bubbleTail = paintBubbleTail();

    canvas.drawRRect(bubbleBody, paint);
    canvas.drawPath(bubbleTail, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
