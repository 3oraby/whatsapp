import 'package:flutter/material.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_story_ring.dart';

class CustomUserStoryItem extends StatelessWidget {
  const CustomUserStoryItem({
    super.key,
    required this.contactStoryEntity,
    this.showBottomDivider = true,
  });

  final bool showBottomDivider;
  final ContactStoryEntity contactStoryEntity;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = AppConstants.storyItemAvatarSize;
    final double horizontalSpacing = AppConstants.storyItemHorizontalPadding;

    // This left padding aligns the Divider with the start of the text,
    // which comes after the avatar and the horizontal spacing
    final double dividerLeftPadding = avatarSize + horizontalSpacing;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomStoryRing(
                segments: contactStoryEntity.totalStoriesCount,
                size: avatarSize,
                imageUrl: contactStoryEntity.profileImage,
                viewedSegments: contactStoryEntity.viewedStoriesCount,
              ),
              HorizontalGap(horizontalSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contactStoryEntity.name,
                      style: AppTextStyles.poppinsBold(context, 22),
                    ),
                    const VerticalGap(4),
                    Text(
                      TimeAgoService.getTimeAgo(
                          contactStoryEntity.stories.first.createdAt),
                      style: AppTextStyles.poppinsRegular(context, 16).copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          showBottomDivider
              ? Padding(
                  padding: EdgeInsets.only(left: dividerLeftPadding),
                  child: const Divider(),
                )
              : const VerticalGap(8),
        ],
      ),
    );
  }
}
