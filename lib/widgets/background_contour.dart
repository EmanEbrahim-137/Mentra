import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class BackgroundContour extends StatelessWidget {
  const BackgroundContour({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _MentaraContourPainter(),
      ),
    );
  }
}

class _MentaraContourPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = AppColors.contourLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Curved topographic arcs matching the design
    final arc1 = Path();
    arc1.moveTo(0, size.height * 0.18);
    arc1.cubicTo(
      size.width * 0.45,
      size.height * 0.22,
      size.width * 0.75,
      size.height * 0.38,
      size.width * 0.95,
      size.height * 0.55,
    );
    canvas.drawPath(arc1, strokePaint);

    final arc2 = Path();
    arc2.moveTo(size.width * 0.1, size.height * 0.12);
    arc2.cubicTo(
      size.width * 0.55,
      size.height * 0.18,
      size.width * 0.85,
      size.height * 0.32,
      size.width,
      size.height * 0.45,
    );
    canvas.drawPath(arc2, strokePaint);

    final arc3 = Path();
    arc3.moveTo(0, size.height * 0.65);
    arc3.cubicTo(
      size.width * 0.35,
      size.height * 0.72,
      size.width * 0.65,
      size.height * 0.88,
      size.width * 0.85,
      size.height,
    );
    canvas.drawPath(arc3, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
