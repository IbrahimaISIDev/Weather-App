import 'dart:math' as math;
import 'package:flutter/material.dart';

class PremiumGaugePainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  PremiumGaugePainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    const strokeWidth = 14.0;

    // 1. Background Track
    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth/2),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      trackPaint,
    );

    // 2. Progress Arc with Glow
    final progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [primaryColor, secondaryColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Glow Effect
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    if (progress > 0) {
      final sweepAngle = math.pi * 1.5 * progress;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth/2),
        math.pi * 0.75,
        sweepAngle,
        false,
        glowPaint,
      );
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth/2),
        math.pi * 0.75,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PremiumGaugePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
