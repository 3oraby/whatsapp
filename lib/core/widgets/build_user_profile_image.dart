import 'package:flutter/material.dart';
import 'package:whatsapp/core/helpers/is_light_theme.dart';
import 'package:whatsapp/core/utils/app_colors.dart';

class BuildUserProfileImage extends StatelessWidget {
  const BuildUserProfileImage({
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
      backgroundColor: isLightTheme(context)
          ? AppColors.highlightBackgroundColor
          : AppColors.highlightBackgroundColorDark,
      child: ClipOval(
        child: profilePicUrl != null
            ? Image.network(
                profilePicUrl!,
                fit: BoxFit.cover,
                width: circleAvatarRadius * 2,
                height: circleAvatarRadius * 2,
                errorBuilder: (context, error, stackTrace) {
                  return CustomPersonIcon(
                      circleAvatarRadius: circleAvatarRadius);
                },
              )
            : CustomPersonIcon(circleAvatarRadius: circleAvatarRadius),
      ),
    );
  }
}

class CustomPersonIcon extends StatelessWidget {
  const CustomPersonIcon({
    super.key,
    required this.circleAvatarRadius,
  });

  final double circleAvatarRadius;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.person_2,
      color: Theme.of(context).colorScheme.secondary,
      size: circleAvatarRadius * 1.5,
    );
  }
}
