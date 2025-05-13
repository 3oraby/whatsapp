import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_story_ring.dart';

class CustomUserStoryItem extends StatelessWidget {
  const CustomUserStoryItem({
    super.key,
    required this.userName,
    required this.storyTimeAgo,
    required this.totalStoriesNumber,
    required this.viewedStoriesNumber,
    this.imageUrl,
    this.showTopDivider = true,
    this.showBottomDivider = true,
  });

  final String userName;
  final String storyTimeAgo;
  final String? imageUrl;
  final bool showTopDivider;
  final bool showBottomDivider;
  final int totalStoriesNumber;
  final int viewedStoriesNumber;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = 80;
    final double horizontalSpacing = 16;

    // This left padding aligns the Divider with the start of the text,
    // which comes after the avatar and the horizontal spacing
    final double dividerLeftPadding = avatarSize + horizontalSpacing;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          if (showTopDivider)
            Padding(
              padding: EdgeInsets.only(left: dividerLeftPadding),
              child: const Divider(),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomStoryRing(
                segments: totalStoriesNumber,
                size: avatarSize,
                imageUrl: imageUrl,
                viewedSegments: viewedStoriesNumber,
              ),
              HorizontalGap(horizontalSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
          if (showBottomDivider)
            Padding(
              padding: EdgeInsets.only(left: dividerLeftPadding),
              child: const Divider(),
            ),
        ],
      ),
    );
  }
}
