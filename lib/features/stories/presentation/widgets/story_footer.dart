import 'package:flutter/material.dart';
import 'package:whatsapp/features/stories/domain/entities/view_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/widgets/show_current_user_story_views.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_interaction_part.dart';

class StoryFooter extends StatelessWidget {
  final bool showCurrentUserStories;
  final List<ViewStoryEntity>? views;
  final TextEditingController textController;
  final ScrollController scrollController;
  final VoidCallback onSheetOpened;
  final VoidCallback onSheetClosed;

  const StoryFooter({
    super.key,
    required this.showCurrentUserStories,
    required this.views,
    required this.textController,
    required this.scrollController,
    required this.onSheetOpened,
    required this.onSheetClosed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showCurrentUserStories)
          ShowCurrentUserStoryViews(
            views: views ?? [],
            onBottomSheetOpened: onSheetOpened,
            onBottomSheetClosed: onSheetClosed,
          )
        else
          StoryInteractionPart(
            textFieldScrollController: scrollController,
            textController: textController,
          ),
      ],
    );
  }
}
