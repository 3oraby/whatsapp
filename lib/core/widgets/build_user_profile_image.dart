import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/helpers/is_light_theme.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/features/auth/presentation/cubits/set_user_profile_picture_cubit/set_user_profile_picture_cubit.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class BuildUserProfileImage extends StatefulWidget {
  const BuildUserProfileImage({
    super.key,
    this.userEntity,
    this.circleAvatarRadius = 30,
    this.profilePicUrl,
    this.isEnabled = true,
    this.isCurrentUser = false,
  });

  final double circleAvatarRadius;
  final UserEntity? userEntity;
  final String? profilePicUrl;
  final bool isEnabled;
  final bool isCurrentUser;

  @override
  State<BuildUserProfileImage> createState() => _BuildUserProfileImageState();
}

class _BuildUserProfileImageState extends State<BuildUserProfileImage> {
  UserEntity? currentUser;
  late String? profilePic;

  @override
  void initState() {
    super.initState();
    if (widget.isCurrentUser) {
      currentUser = getCurrentUserEntity()!;
    }
    profilePic = widget.profilePicUrl ??
        widget.userEntity?.profileImage ??
        currentUser?.profileImage;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SetUserProfilePictureCubit, SetUserProfilePictureState>(
      listener: (BuildContext context, SetUserProfilePictureState state) {
        if (widget.isCurrentUser) {
          if (state is SetUserProfilePictureLoadedState ||
              state is DeletedUserProfilePictureLoadedState) {
            setState(() {
              currentUser = getCurrentUserEntity()!;
              profilePic = currentUser!.profileImage;
            });
          }
        }
      },
      child: GestureDetector(
        onTap: !widget.isEnabled
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.userProfileRoute,
                  arguments:
                      widget.isCurrentUser ? currentUser : widget.userEntity,
                );
              },
        child: CircleAvatar(
          radius: widget.circleAvatarRadius,
          backgroundColor: isLightTheme(context)
              ? AppColors.highlightBackgroundColor
              : AppColors.highlightBackgroundColorDark,
          child: ClipOval(
            child: profilePic != null
                ? CachedNetworkImage(
                    imageUrl: profilePic!,
                    fit: BoxFit.cover,
                    width: widget.circleAvatarRadius * 2,
                    height: widget.circleAvatarRadius * 2,
                    errorWidget: (context, error, stackTrace) {
                      return CustomPersonIcon(
                          circleAvatarRadius: widget.circleAvatarRadius);
                    },
                  )
                : CustomPersonIcon(
                    circleAvatarRadius: widget.circleAvatarRadius,
                  ),
          ),
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
