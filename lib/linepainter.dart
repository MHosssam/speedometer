import 'dart:math';

import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final Color lineColor;
  final Color completeColor;
  final double startPercent;
  final double endPercent;
  final double width;
  final int startValue;
  final int endValue;
  final angle = 2 * pi / 60;

  LinePainter({
    required this.lineColor,
    required this.completeColor,
    required this.startValue,
    required this.endValue,
    required this.startPercent,
    required this.endPercent,
    required this.width,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(
      size.width / 2,
      size.height / 2,
    );
    double radius = min(
      size.width / 2,
      size.height / 2,
    );
    canvas.drawArc(
      new Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      25 * angle,
      40 * angle,
      false,
      line,
    );

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        25 * angle + (40 * angle) * startPercent,
        (40 * angle) * (endPercent - startPercent),
        false,
        complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
