import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/utils/app_themes.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetCurrentStoriesCubit(
        storiesRepo: getIt<StoriesRepo>(),
      ),
      child: const ShowCurrentStoriesBody(),
    );
  }
}

class ShowCurrentStoriesBody extends StatelessWidget {
  const ShowCurrentStoriesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const VerticalGap(100),
          CustomContactStory(
            userName: "oraby",
            storyTimeAgo: "3 min ago",
            imageUrl:
                "https://th.bing.com/th/id/OIP.9I78FXC8CudGMDllr7iF2QHaKv?w=134&h=195&c=7&r=0&o=5&cb=iwc2&dpr=1.3&pid=1.7",
          ),
        ],
      ),
    );
  }
}

class CustomContactStory extends StatelessWidget {
  const CustomContactStory({
    super.key,
    required this.userName,
    required this.storyTimeAgo,
    this.imageUrl,
    this.showFirstDivider = true,
    this.showLastDivider = true,
  });

  final String userName;
  final String storyTimeAgo;
  final String? imageUrl;
  final bool showFirstDivider;
  final bool showLastDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Visibility(
            visible: showFirstDivider,
            child: const Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StoryRing(
                segments: 5,
                size: 80,
                imageUrl: imageUrl,
                viewedSegments: 1,
              ),
              const HorizontalGap(16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: showFirstDivider,
                      child: const Divider(),
                    ),
                    Text(
                      userName,
                      style: AppTextStyles.poppinsBold(context, 22),
                    ),
                    const VerticalGap(4),
                    Text(
                      storyTimeAgo,
                      style: AppTextStyles.poppinsRegular(context, 16).copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Visibility(
                      visible: showLastDivider,
                      child: const Divider(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 80 + 16),
            child: Visibility(
              visible: showLastDivider,
              child: const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}

class StoryRing extends StatelessWidget {
  final int segments;
  final int viewedSegments;
  final double size;
  final String? imageUrl;

  const StoryRing({
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
            painter: _StoryRingPainter(
              segments: segments,
              viewedSegments: viewedSegments,
              strokeWidth: strokeWidth,
            ),
          ),
          ClipOval(
            child: SizedBox(
              width: size - strokeWidth * 2,
              height: size - strokeWidth * 2,
              child: BuildUserProfileImage(
                circleAvatarRadius: size - strokeWidth * 2,
                profilePicUrl: imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryRingPainter extends CustomPainter {
  final int segments;
  final int viewedSegments;
  final double strokeWidth;

  _StoryRingPainter({
    required this.segments,
    required this.viewedSegments,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;
    final gapSize = 2 * pi / 60;
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
  bool shouldRepaint(covariant _StoryRingPainter oldDelegate) =>
      oldDelegate.segments != segments ||
      oldDelegate.viewedSegments != viewedSegments ||
      oldDelegate.strokeWidth != strokeWidth;
}
