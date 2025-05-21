import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_constants.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/create_new_story_loading.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_story_ring.dart';

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
    return BlocBuilder<CreateNewStoryCubit, CreateNewStoryState>(
      builder: (context, state) => InkWell(
        onTap: () {
          BlocProvider.of<GetCurrentStoriesCubit>(context)
              .selectedContactStoryEntity = contactStoryEntity;
          Navigator.pushNamed(
            context,
            Routes.userStoriesViewerRoute,
            arguments: BlocProvider.of<GetCurrentStoriesCubit>(context),
          );
        },
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomStoryRing(
                segments: contactStoryEntity.totalStoriesCount,
                size: avatarSize,
                imageUrl: contactStoryEntity.profileImage,
                viewedSegments: contactStoryEntity.totalStoriesCount,
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
                            TimeAgoService.getTimeAgo(
                                contactStoryEntity.stories.first.createdAt),
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
