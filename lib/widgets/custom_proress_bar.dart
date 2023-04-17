import 'package:flutter/material.dart';
import '../common/colors.dart';
import '../common/sizes.dart';

class CustomProgressBar extends CustomPainter {
  CustomProgressBar({required this.animationOffset});

  final double animationOffset;

  @override
  void paint(Canvas canvas, Size size) {
    const Radius rectRadius = Radius.circular(0);

    final strockPaint = Paint()
      ..color = white20
      ..strokeWidth = strockWidth;

    final rectanglePaint = Paint()
      ..color = blue
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        0,
        0,
        size.width,
        size.height,
      ),
      rectRadius,
    );

    canvas.drawRRect(rect, rectanglePaint);
    for (double i = spaceBetweenStrock * -1.5; i <= size.width; i += spaceBetweenStrock) {
      canvas.drawLine(
        Offset(i + animationOffset - 5, -5),
        Offset(size.height + i + animationOffset + 5, size.height + 5),
        strockPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
