import 'package:flutter/material.dart';

class SidebarPainter extends CustomPainter {
  final BuildContext context;
  final bool isArabic;

  SidebarPainter(this.context, {required this.isArabic});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Theme.of(context).primaryColor // Solid color, e.g., deep blue
      ..style = PaintingStyle.fill;

    // Rounded rectangle path
    RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Repaint only if language or size changes
  }
}
