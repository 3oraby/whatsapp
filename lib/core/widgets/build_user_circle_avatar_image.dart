import 'package:flutter/material.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_images.dart';

class BuildUserCircleAvatarImage extends StatelessWidget {
  const BuildUserCircleAvatarImage({
    super.key,
    required this.profilePicUrl,
    this.circleAvatarRadius = 30,
  });

  final String? profilePicUrl;
  final double circleAvatarRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: circleAvatarRadius,
      backgroundColor: profilePicUrl == null
          ? Colors.white
          : AppColors.highlightBackgroundColor,
      backgroundImage: profilePicUrl != null
          ? NetworkImage(
              profilePicUrl!,
            )
          : const AssetImage(
              AppImages.imagesDefaultProfilePicture,
            ),
      onBackgroundImageError: (error, stackTrace) {
        const AssetImage(AppImages.imagesDefaultProfilePicture);
      },
    );
  }
}
