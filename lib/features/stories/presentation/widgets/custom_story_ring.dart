import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_ring_painter.dart';

class CustomStoryRing extends StatelessWidget {
  final int segments;
  final int viewedSegments;
  final double size;
  final String? imageUrl;

  const CustomStoryRing({
    super.key,
    required this.segments,
    this.viewedSegments = 0,
    required this.size,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    const strokeWidth = 4.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: StoryRingPainter(
              segments: segments,
              viewedSegments: viewedSegments,
              strokeWidth: strokeWidth,
            ),
          ),
          ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: SizedBox(
                width: size - strokeWidth * 2,
                height: size - strokeWidth * 2,
                child: BuildUserProfileImage(
                  circleAvatarRadius: size - strokeWidth * 2,
                  profilePicUrl: imageUrl,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
