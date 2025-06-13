import 'package:flutter/material.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/presentation/widgets/show_current_user_story_views.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_interaction_part.dart';

class StoryFooter extends StatelessWidget {
  final bool showCurrentUserStories;
  final TextEditingController textController;
  final ScrollController scrollController;
  final VoidCallback onSheetOpened;
  final VoidCallback onSheetClosed;
  final StoryEntity storyEntity;
  final int currentStoryIndex;

  const StoryFooter({
    super.key,
    required this.showCurrentUserStories,
    required this.textController,
    required this.scrollController,
    required this.onSheetOpened,
    required this.onSheetClosed,
    required this.storyEntity,
    required this.currentStoryIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showCurrentUserStories)
          ShowCurrentUserStoryViews(
            views: storyEntity.views ?? [],
            onBottomSheetOpened: onSheetOpened,
            onBottomSheetClosed: onSheetClosed,
          )
        else
          StoryInteractionPart(
            textFieldScrollController: scrollController,
            textController: textController,
            storyEntity: storyEntity,
            currentStoryIndex: currentStoryIndex,
          ),
      ],
    );
  }
}
