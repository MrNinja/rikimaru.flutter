import 'dart:math';

import 'package:flutter/material.dart';

class CycleProcessPainter extends CustomPainter {
  final Color lineColor;
  final Color completeColor;
  final double completePercent;
  final double width;

  CycleProcessPainter({
    this.lineColor,
    this.completeColor,
    this.completePercent,
    this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);
    canvas.drawCircle(center, radius, linePaint);

    Paint processPaint = Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    double arcAngle = 2 * pi * (completePercent / 100);
    Rect processRectangle = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(processRectangle, -pi / 2, arcAngle, false, processPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
