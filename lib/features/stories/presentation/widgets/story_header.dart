import 'package:flutter/material.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/leading_arrow_back.dart';

class StoryHeader extends StatelessWidget {
  final String name;
  final String? profileImage;
  final DateTime createdAt;
  final bool isCurrentUser;

  const StoryHeader({
    super.key,
    required this.name,
    required this.profileImage,
    required this.createdAt,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const LeadingArrowBack(color: Colors.white),
        const HorizontalGap(12),
        BuildUserProfileImage(
          circleAvatarRadius: 20,
          profilePicUrl: isCurrentUser ? null : profileImage,
          isEnabled: false,
          isCurrentUser: isCurrentUser,
        ),
        const HorizontalGap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: AppTextStyles.poppinsMedium(context, 16)
                  .copyWith(color: Colors.white),
            ),
            Text(
              TimeAgoService.formatTimeForDisplay(createdAt),
              style: AppTextStyles.poppinsRegular(context, 14)
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
