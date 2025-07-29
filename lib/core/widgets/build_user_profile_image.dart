import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/core/helpers/is_light_theme.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class BuildUserProfileImage extends StatelessWidget {
  const BuildUserProfileImage({
    super.key,
    this.userEntity,
    this.circleAvatarRadius = 30,
    this.profilePicUrl,
  });

  final double circleAvatarRadius;
  final UserEntity? userEntity;
  final String? profilePicUrl;

  @override
  Widget build(BuildContext context) {
    final String? profilePic = profilePicUrl ?? userEntity?.profileImage;
    return GestureDetector(
      onTap: () {
        if (userEntity != null) {
          Navigator.pushNamed(
            context,
            Routes.userProfileRoute,
            arguments: userEntity,
          );
        }
      },
      child: CircleAvatar(
        radius: circleAvatarRadius,
        backgroundColor: isLightTheme(context)
            ? AppColors.highlightBackgroundColor
            : AppColors.highlightBackgroundColorDark,
        child: ClipOval(
          child: profilePic != null
              ? CachedNetworkImage(
                  imageUrl: profilePic,
                  fit: BoxFit.cover,
                  width: circleAvatarRadius * 2,
                  height: circleAvatarRadius * 2,
                  errorWidget: (context, error, stackTrace) {
                    return CustomPersonIcon(
                        circleAvatarRadius: circleAvatarRadius);
                  },
                )
              : CustomPersonIcon(circleAvatarRadius: circleAvatarRadius),
        ),
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
