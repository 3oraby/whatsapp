import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/routes/create_new_story_args.dart';
import 'package:whatsapp/features/stories/presentation/widgets/create_new_story_loading.dart';

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

    return BlocBuilder<CreateNewStoryCubit, CreateNewStoryState>(
      builder: (context, state) => InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.createNewStoryRoute,
            arguments: CreateNewStoryArgs(
              cubit: context.read<CreateNewStoryCubit>(),
              initialTab: 1,
            ),
          );
        },
        child: SizedBox(
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
                    isEnabled: false,
                    isCurrentUser: true,
                  ),
                  Positioned(
                    right: -3,
                    bottom: -3,
                    child: Icon(
                      Icons.add_circle,
                      color: AppColors.primary,
                      size: AppConstants.myStoryItemAddIconSize,
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
                    state is CreateNewStoryLoadingState
                        ? CreateNewStoryLoading()
                        : Text(
                            "Add to my status",
                            style: AppTextStyles.poppinsRegular(context, 16)
                                .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
