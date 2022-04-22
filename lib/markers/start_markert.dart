import 'package:flutter/material.dart';

class StartMarkerPointer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint().color = Colors.black;

    canvas.drawCircle(Offset(20, size.height - 20), 20, Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
