import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_error_body_widget.dart';
import 'package:whatsapp/core/widgets/custom_loading_body_widget.dart';
import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/show_current_stories_body.dart';

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
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).iconTheme.color,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.createNewStoryRoute,
                    arguments: context.read<CreateNewStoryCubit>(),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: AppColors.primary,
                  size: 36,
                ),
                onPressed: () {
                  //! make default for the photo not text
                  Navigator.pushNamed(
                    context,
                    Routes.createNewStoryRoute,
                    arguments: context.read<CreateNewStoryCubit>(),
                  );
                },
              ),
            ],
          ),
          Expanded(
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
                    currentUserContactStoryEntity:
                        state.currentUserContactStoryEntity,
                    unViewedContactsStories:
                        state.userContactsStories.unViewedContacts,
                    viewedContactsStories:
                        state.userContactsStories.viewedContacts,
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
