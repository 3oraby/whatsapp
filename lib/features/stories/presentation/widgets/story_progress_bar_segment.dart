
import 'package:flutter/material.dart';

class StoryProgressBarSegment extends StatelessWidget {
  final bool isSeen;
  final bool isCurrent;
  final AnimationController? controller;

  const StoryProgressBarSegment({
    super.key,
    required this.isSeen,
    required this.isCurrent,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller ?? AlwaysStoppedAnimation(0.0),
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: isSeen
                ? 1.0
                : isCurrent
                    ? controller?.value ?? 0.0
                    : 0.0,
            backgroundColor: Colors.white30,
            color: Colors.white,
          ),
        );
      },
    );
  }
}