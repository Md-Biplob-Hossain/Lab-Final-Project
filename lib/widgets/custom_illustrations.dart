import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 1. Welcome Screen Illustration
class WelcomeIllustration extends StatelessWidget {
  final double height;
  const WelcomeIllustration({super.key, this.height = 220});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _WelcomeIllustrationPainter(),
      ),
    );
  }
}

class _WelcomeIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Large Yellow Question Mark behind head
    final yellowPaint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..style = PaintingStyle.fill;

    final yellowPath = Path();
    yellowPath.moveTo(center.dx - 20, center.dy - 70);
    yellowPath.cubicTo(
      center.dx - 60, center.dy - 100,
      center.dx + 20, center.dy - 110,
      center.dx + 10, center.dy - 50,
    );
    yellowPath.cubicTo(
      center.dx + 5, center.dy - 20,
      center.dx - 30, center.dy - 20,
      center.dx - 30, center.dy + 10,
    );
    yellowPath.lineTo(center.dx - 5, center.dy + 10);
    yellowPath.cubicTo(
      center.dx - 5, center.dy - 10,
      center.dx + 30, center.dy - 10,
      center.dx + 35, center.dy - 50,
    );
    yellowPath.cubicTo(
      center.dx + 45, center.dy - 125,
      center.dx - 80, center.dy - 115,
      center.dx - 40, center.dy - 65,
    );
    yellowPath.close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Yellow dot below
    canvas.drawCircle(Offset(center.dx - 18, center.dy + 25), 8, yellowPaint);

    // 2. Floating accent shapes (Pink oval bubble top left)
    final pinkPaint = Paint()..color = const Color(0xFFFF6B81);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 85, center.dy - 50),
        width: 36,
        height: 26,
      ),
      pinkPaint,
    );
    // Green stripe in bubble
    final greenPaint = Paint()..color = const Color(0xFF2ED573);
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(center.dx - 85, center.dy - 50),
        width: 22,
        height: 4,
      ),
      greenPaint,
    );

    // Red Question mark on right
    final redPaint = Paint()
      ..color = const Color(0xFFFF4757)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final redQPath = Path();
    redQPath.moveTo(center.dx + 70, center.dy - 55);
    redQPath.cubicTo(
      center.dx + 60, center.dy - 75,
      center.dx + 90, center.dy - 75,
      center.dx + 80, center.dy - 40,
    );
    redQPath.lineTo(center.dx + 70, center.dy - 25);
    canvas.drawPath(redQPath, redPaint);
    canvas.drawCircle(
      Offset(center.dx + 70, center.dy - 12),
      3,
      redPaint..style = PaintingStyle.fill,
    );

    // Green Question mark bottom right
    final greenQPaint = Paint()
      ..color = const Color(0xFF2ED573)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final greenQPath = Path();
    greenQPath.moveTo(center.dx + 65, center.dy + 25);
    greenQPath.cubicTo(
      center.dx + 55, center.dy + 10,
      center.dx + 80, center.dy + 10,
      center.dx + 70, center.dy + 35,
    );
    greenQPath.lineTo(center.dx + 65, center.dy + 45);
    canvas.drawPath(greenQPath, greenQPaint);
    canvas.drawCircle(
      Offset(center.dx + 65, center.dy + 54),
      2.5,
      greenQPaint..style = PaintingStyle.fill,
    );

    // Orange circle bottom left
    final orangePaint = Paint()..color = const Color(0xFFFFA502);
    canvas.drawCircle(Offset(center.dx - 80, center.dy + 35), 14, orangePaint);

    // Swooshes
    final strokePaint = Paint()
      ..color = const Color(0xFF70A1FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx + 55, center.dy - 75), radius: 15),
      0.2,
      1.2,
      false,
      strokePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx - 65, center.dy - 75), radius: 12),
      3.5,
      1.2,
      false,
      strokePaint..color = const Color(0xFF9C88FF),
    );

    // 3. Main Character Head
    final skinPaint = Paint()..color = const Color(0xFFFFD8B9);
    final hairPaint = Paint()..color = const Color(0xFF7C4DFF);

    // Ears
    canvas.drawCircle(Offset(center.dx - 32, center.dy), 10, skinPaint);
    canvas.drawCircle(Offset(center.dx + 32, center.dy), 10, skinPaint);

    // Face Circle
    canvas.drawCircle(Offset(center.dx, center.dy), 32, skinPaint);

    // Purple Hair (Bouncy cloud-like circles)
    canvas.drawCircle(Offset(center.dx - 22, center.dy - 25), 18, hairPaint);
    canvas.drawCircle(Offset(center.dx, center.dy - 32), 20, hairPaint);
    canvas.drawCircle(Offset(center.dx + 22, center.dy - 25), 18, hairPaint);
    canvas.drawCircle(Offset(center.dx - 30, center.dy - 12), 14, hairPaint);
    canvas.drawCircle(Offset(center.dx + 30, center.dy - 12), 14, hairPaint);

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF2C3E50);
    canvas.drawCircle(Offset(center.dx - 12, center.dy - 2), 3.5, eyePaint);
    canvas.drawCircle(Offset(center.dx + 12, center.dy - 2), 3.5, eyePaint);

    // Blush cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFF8A80).withValues(alpha: 0.6);
    canvas.drawCircle(Offset(center.dx - 18, center.dy + 8), 4.5, cheekPaint);
    canvas.drawCircle(Offset(center.dx + 18, center.dy + 8), 4.5, cheekPaint);

    // Freckles
    final frecklePaint = Paint()..color = const Color(0xFFA1887F);
    canvas.drawCircle(Offset(center.dx - 8, center.dy + 4), 1, frecklePaint);
    canvas.drawCircle(Offset(center.dx - 5, center.dy + 6), 1, frecklePaint);
    canvas.drawCircle(Offset(center.dx + 5, center.dy + 6), 1, frecklePaint);
    canvas.drawCircle(Offset(center.dx + 8, center.dy + 4), 1, frecklePaint);

    // Cute mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    mouthPath.moveTo(center.dx - 4, center.dy + 14);
    mouthPath.quadraticBezierTo(center.dx, center.dy + 18, center.dx + 4, center.dy + 14);
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 2. Config / Toggle Settings Illustration (Matching Figma Screen 3 & Screen 5 right)
class ConfigIllustration extends StatelessWidget {
  final double height;
  const ConfigIllustration({super.key, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ConfigIllustrationPainter(),
      ),
    );
  }
}

class _ConfigIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final linePaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // 1. Soft Light Blue rounded card backdrop
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: 140, height: 110),
      const Radius.circular(20),
    );
    canvas.drawRRect(
      bgRect,
      Paint()..color = const Color(0xFFD6EAF8),
    );
    canvas.drawRRect(bgRect, linePaint);

    // 2. Yellow Gear Card on top-left
    final gearCardRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx - 35, center.dy - 20), width: 50, height: 50),
      const Radius.circular(12),
    );
    canvas.drawRRect(
      gearCardRect,
      Paint()..color = const Color(0xFFF9E79F),
    );
    canvas.drawRRect(gearCardRect, linePaint);

    // Draw gear wheel
    final gearCenter = Offset(center.dx - 35, center.dy - 20);
    final gearPaint = Paint()
      ..color = const Color(0xFFB7950B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(gearCenter, 10, gearPaint);
    canvas.drawCircle(gearCenter, 4, gearPaint..strokeWidth = 2);

    // Gear teeth
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3);
      final p1 = gearCenter + Offset(math.cos(angle) * 10, math.sin(angle) * 10);
      final p2 = gearCenter + Offset(math.cos(angle) * 14, math.sin(angle) * 14);
      canvas.drawLine(p1, p2, gearPaint..strokeWidth = 3);
    }

    // 3. Toggles on right
    // Top toggle box
    final toggle1Rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + 25, center.dy - 25), width: 55, height: 22),
      const Radius.circular(11),
    );
    canvas.drawRRect(toggle1Rect, Paint()..color = const Color(0xFFFF5252));
    canvas.drawRRect(toggle1Rect, linePaint);
    // Blue left section
    final toggle1Blue = RRect.fromRectAndRadius(
      Rect.fromLTWH(center.dx - 2.5, center.dy - 36, 28, 22),
      const Radius.circular(11),
    );
    canvas.drawRRect(toggle1Blue, Paint()..color = const Color(0xFF64B5F6));
    canvas.drawRRect(toggle1Blue, linePaint);
    // Pink knob
    canvas.drawCircle(Offset(center.dx + 12, center.dy - 25), 8, Paint()..color = const Color(0xFFFF80AB));
    canvas.drawCircle(Offset(center.dx + 12, center.dy - 25), 8, linePaint);

    // Bottom toggle box
    final toggle2Rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(center.dx + 25, center.dy + 10), width: 55, height: 22),
      const Radius.circular(11),
    );
    canvas.drawRRect(toggle2Rect, Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawRRect(toggle2Rect, linePaint);
    // Pink knob
    canvas.drawCircle(Offset(center.dx + 38, center.dy + 10), 8, Paint()..color = const Color(0xFFFF80AB));
    canvas.drawCircle(Offset(center.dx + 38, center.dy + 10), 8, linePaint);

    // 4. Hand with sleeve pointing upwards
    final handCenter = Offset(center.dx - 10, center.dy + 25);

    // Blue striped sleeve
    final sleevePath = Path();
    sleevePath.moveTo(handCenter.dx - 25, handCenter.dy + 35);
    sleevePath.lineTo(handCenter.dx - 5, handCenter.dy + 10);
    sleevePath.lineTo(handCenter.dx + 10, handCenter.dy + 20);
    sleevePath.lineTo(handCenter.dx - 10, handCenter.dy + 35);
    sleevePath.close();
    canvas.drawPath(sleevePath, Paint()..color = const Color(0xFF2979FF));
    canvas.drawPath(sleevePath, linePaint);

    // Dark skin hand finger pointing to top toggle knob
    final fingerPath = Path();
    fingerPath.moveTo(handCenter.dx - 2, handCenter.dy + 12);
    fingerPath.lineTo(handCenter.dx + 5, handCenter.dy - 18);
    fingerPath.arcToPoint(
      Offset(handCenter.dx + 14, handCenter.dy - 18),
      radius: const Radius.circular(5),
    );
    fingerPath.lineTo(handCenter.dx + 18, handCenter.dy + 8);
    fingerPath.close();

    canvas.drawPath(fingerPath, Paint()..color = const Color(0xFF6D4C41));
    canvas.drawPath(fingerPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3. Celebration / Confetti Party Popper Illustration (Matching Figma Screen 5 left)
class ConfettiIllustration extends StatelessWidget {
  final double height;
  const ConfettiIllustration({super.key, this.height = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _ConfettiIllustrationPainter(),
      ),
    );
  }
}

class _ConfettiIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 10);

    // 1. Party Horn (Cone)
    final hornPaint = Paint()..color = const Color(0xFFFF80AB); // Pink
    final whiteStripesPaint = Paint()..color = const Color(0xFFFCE4EC);

    final hornPath = Path();
    hornPath.moveTo(center.dx - 65, center.dy + 45);
    hornPath.lineTo(center.dx + 15, center.dy - 40);
    hornPath.lineTo(center.dx + 45, center.dy - 10);
    hornPath.lineTo(center.dx - 40, center.dy + 65);
    hornPath.close();

    canvas.drawPath(hornPath, hornPaint);

    // Rim of the horn (oval opening)
    final rimCenter = Offset(center.dx + 30, center.dy - 25);
    canvas.drawOval(
      Rect.fromCenter(center: rimCenter, width: 60, height: 45),
      Paint()..color = const Color(0xFFF48FB1),
    );
    canvas.drawOval(
      Rect.fromCenter(center: rimCenter, width: 46, height: 32),
      Paint()..color = const Color(0xFFAD1457),
    );

    // Stripe 1
    final stripe1 = Path();
    stripe1.moveTo(center.dx - 40, center.dy + 20);
    stripe1.lineTo(center.dx - 15, center.dy - 10);
    stripe1.lineTo(center.dx - 2, center.dy + 5);
    stripe1.lineTo(center.dx - 25, center.dy + 35);
    stripe1.close();
    canvas.drawPath(stripe1, whiteStripesPaint);

    // Stripe 2
    final stripe2 = Path();
    stripe2.moveTo(center.dx - 10, center.dy - 15);
    stripe2.lineTo(center.dx + 10, center.dy - 35);
    stripe2.lineTo(center.dx + 25, center.dy - 20);
    stripe2.lineTo(center.dx + 8, center.dy);
    stripe2.close();
    canvas.drawPath(stripe2, whiteStripesPaint);

    // 2. Confetti flying out
    final confettiColors = [
      const Color(0xFF42A5F5), // Blue
      const Color(0xFF66BB6A), // Green
      const Color(0xFFFFCA28), // Yellow
      const Color(0xFFFF7043), // Orange
      const Color(0xFFAB47BC), // Purple
    ];

    final random = math.Random(42);
    for (int i = 0; i < 24; i++) {
      final color = confettiColors[i % confettiColors.length];
      final paint = Paint()..color = color;

      final angle = -math.pi / 4 + (random.nextDouble() - 0.5) * 1.5;
      final dist = 40 + random.nextDouble() * 90;
      final cx = rimCenter.dx + math.cos(angle) * dist;
      final cy = rimCenter.dy + math.sin(angle) * dist;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(random.nextDouble() * math.pi);

      if (i % 3 == 0) {
        // Rectangle ribbon
        canvas.drawRect(const Rect.fromLTWH(-6, -3, 12, 6), paint);
      } else if (i % 3 == 1) {
        // Curved ribbon
        final ribbonPath = Path();
        ribbonPath.moveTo(-8, -4);
        ribbonPath.quadraticBezierTo(0, 4, 8, -4);
        canvas.drawPath(
          ribbonPath,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
      } else {
        // Circle dot
        canvas.drawCircle(Offset.zero, 3.5, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
