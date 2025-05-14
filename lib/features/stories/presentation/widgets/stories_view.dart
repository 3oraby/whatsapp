import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_error_body_widget.dart';
import 'package:whatsapp/core/widgets/custom_loading_body_widget.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_user_story_item.dart';

class StoriesView extends StatelessWidget {
  const StoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetCurrentStoriesCubit(
        storiesRepo: getIt<StoriesRepo>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // title: Text(
          //   "Updates",
          //   style: AppTextStyles.poppinsBold(context, 22),
          // ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).iconTheme.color,
                size: 30,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.camera_alt,
                color: AppColors.primary,
                size: 36,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ShowCurrentStoriesBlocBuilderBody(),
      ),
    );
  }
}

class ShowCurrentStoriesBlocBuilderBody extends StatefulWidget {
  const ShowCurrentStoriesBlocBuilderBody({super.key});

  @override
  State<ShowCurrentStoriesBlocBuilderBody> createState() =>
      _ShowCurrentStoriesBlocBuilderBodyState();
}

class _ShowCurrentStoriesBlocBuilderBodyState
    extends State<ShowCurrentStoriesBlocBuilderBody> {
  @override
  void initState() {
    super.initState();
    getCurrentStories();
  }

  void getCurrentStories() {
    BlocProvider.of<GetCurrentStoriesCubit>(context).getCurrentStories();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppPadding(
      child: BlocBuilder<GetCurrentStoriesCubit, GetCurrentStoriesState>(
        builder: (context, state) {
          if (state is GetCurrentStoriesLoadingState) {
            return CustomLoadingBodyWidget();
          } else if (state is GetCurrentStoriesFailureState) {
            return CustomErrorBodyWidget(
              errorMessage: state.message,
              onRetry: getCurrentStories,
            );
          } else if (state is GetCurrentStoriesLoadedState) {
            return ShowCurrentStoriesBody(
              unViewedContactsStories:
                  state.userContactsStories.unViewedContacts,
              viewedContactsStories: state.userContactsStories.viewedContacts,
            );
          }
          //  else if (state is GetCurrentStoriesEmptyState) {
          //   return const CustomEmptyStateBody(
          //     title: "No users found",
          //     icon: Icons.person_search,
          //   );
          // }
          return SizedBox();
        },
      ),
    );
  }
}

class ShowCurrentStoriesBody extends StatelessWidget {
  const ShowCurrentStoriesBody({
    super.key,
    required this.viewedContactsStories,
    required this.unViewedContactsStories,
  });

  final List<ContactStoryEntity> viewedContactsStories;
  final List<ContactStoryEntity> unViewedContactsStories;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CustomAppPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Updates",
              style: AppTextStyles.poppinsBold(context, 48),
            ),
            const VerticalGap(24),
            const VerticalGap(24),
            Text(
              "Recent updates",
              style: AppTextStyles.poppinsMedium(context, 18).copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const VerticalGap(24),
            ShowUserStoriesList(stories: unViewedContactsStories),
            const VerticalGap(24),
            Text(
              "Viewed updates",
              style: AppTextStyles.poppinsMedium(context, 18).copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const VerticalGap(24),
            ShowUserStoriesList(stories: viewedContactsStories),
            const VerticalGap(24),
          ],
        ),
      ),
    );
  }
}

class ShowUserStoriesList extends StatelessWidget {
  const ShowUserStoriesList({
    super.key,
    required this.stories,
  });

  final List<ContactStoryEntity> stories;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stories.length,
      itemBuilder: (context, index) =>
          CustomUserStoryItem(contactStoryEntity: stories[index]),
    );
  }
}
