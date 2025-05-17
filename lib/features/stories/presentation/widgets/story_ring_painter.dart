import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';

class StoryRingPainter extends CustomPainter {
  final int segments;
  final int viewedSegments;
  final double strokeWidth;

  StoryRingPainter({
    required this.segments,
    required this.viewedSegments,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    final hasGap = segments > 1;
    final gapSize = hasGap ? 2 * pi / 60 : 0;
    final segmentAngle = (2 * pi / segments) - gapSize;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < segments; i++) {
      final startAngle = i * (2 * pi / segments);
      paint.color = i < viewedSegments ? Colors.grey[400]! : AppColors.primary;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StoryRingPainter oldDelegate) =>
      oldDelegate.segments != segments ||
      oldDelegate.viewedSegments != viewedSegments ||
      oldDelegate.strokeWidth != strokeWidth;
}
