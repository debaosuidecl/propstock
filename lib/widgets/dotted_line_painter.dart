import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final spaceBetweenDots = 4.0;
    final dashWidth = 2.0;

    double yOffset = 0;
    while (yOffset < size.height) {
      canvas.drawLine(Offset(size.width / 2, yOffset),
          Offset(size.width / 2, yOffset + dashWidth), paint);
      yOffset += spaceBetweenDots + dashWidth;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
