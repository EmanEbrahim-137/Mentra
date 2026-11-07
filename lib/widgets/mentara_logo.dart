import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class MentaraLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;

  const MentaraLogo({
    super.key,
    this.iconSize = 22,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(iconSize * 1.18, iconSize),
          painter: _MentaraIconPainter(),
        ),
        const SizedBox(width: 8),
        Text(
          'mentara',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _MentaraIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    // Draw the two slanted rounded capsules of Mentara
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.rotate(-0.38);

    // Left pill (shorter, offset left)
    final leftPill = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: const Offset(-5.0, 3.0),
        width: 6.5,
        height: 15.0,
      ),
      const Radius.circular(3.5),
    );
    canvas.drawRRect(leftPill, paint);

    // Right pill (longer, offset right)
    final rightPill = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: const Offset(4.0, -3.0),
        width: 6.5,
        height: 21.0,
      ),
      const Radius.circular(3.5),
    );
    canvas.drawRRect(rightPill, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
