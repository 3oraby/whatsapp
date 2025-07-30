import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_ring_painter.dart';

class CustomStoryRing extends StatelessWidget {
  final int segments;
  final int viewedSegments;
  final double size;
  final String? imageUrl;
  final bool isCurrentUser;

  const CustomStoryRing({
    super.key,
    required this.segments,
    this.viewedSegments = 0,
    required this.size,
    this.imageUrl,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
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
              strokeWidth: AppConstants.strokeWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: SizedBox(
              width: size - AppConstants.strokeWidth * 2,
              height: size - AppConstants.strokeWidth * 2,
              child: BuildUserProfileImage(
                circleAvatarRadius: (size - AppConstants.strokeWidth * 2) / 2,
                profilePicUrl: imageUrl,
                isCurrentUser: isCurrentUser,
                isEnabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
