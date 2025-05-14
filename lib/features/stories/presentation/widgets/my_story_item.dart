import 'package:flutter/material.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_story_ring.dart';

class MyStoryItem extends StatelessWidget {
  const MyStoryItem({
    super.key,
    required this.contactStoryEntity,
  });

  final ContactStoryEntity contactStoryEntity;
  @override
  Widget build(BuildContext context) {
    return contactStoryEntity.stories.isEmpty
        ? MyStoryAddPromptItem(
            currentUserProfileImage: contactStoryEntity.profileImage,
          )
        : MyStoryWithStatusItem(contactStoryEntity: contactStoryEntity);
  }
}

class MyStoryWithStatusItem extends StatelessWidget {
  const MyStoryWithStatusItem({
    super.key,
    required this.contactStoryEntity,
  });

  final ContactStoryEntity contactStoryEntity;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = AppConstants.storyItemAvatarSize;
    final double horizontalSpacing = AppConstants.storyItemHorizontalPadding;
    return SizedBox(
      width: double.infinity,
      child: Row(
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
                  "My status",
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
    );
  }
}

class MyStoryAddPromptItem extends StatelessWidget {
  const MyStoryAddPromptItem({
    super.key,
    this.currentUserProfileImage,
  });
  final String? currentUserProfileImage;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = AppConstants.storyItemAvatarSize;
    final double horizontalSpacing = AppConstants.storyItemHorizontalPadding;

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              BuildUserProfileImage(
                circleAvatarRadius: avatarSize / 2,
                profilePicUrl: currentUserProfileImage,
              ),
              Positioned(
                right: -3,
                bottom: -3,
                child: Icon(
                  Icons.add_circle,
                  color: AppColors.primary,
                  size: 30,
                ),
              )
            ],
          ),
          HorizontalGap(horizontalSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My status",
                  style: AppTextStyles.poppinsBold(context, 22),
                ),
                const VerticalGap(4),
                Text(
                  "Add to my status",
                  style: AppTextStyles.poppinsRegular(context, 16).copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
