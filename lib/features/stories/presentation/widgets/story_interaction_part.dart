import 'package:flutter/material.dart';
import 'package:whatsapp/core/widgets/custom_scrollable_text_field.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/presentation/widgets/custom_react_story_button.dart';

class StoryInteractionPart extends StatelessWidget {
  const StoryInteractionPart({
    super.key,
    required this.textFieldScrollController,
    required this.textController,
    required this.storyEntity,
    required this.currentStoryIndex,
  });

  final ScrollController textFieldScrollController;
  final TextEditingController textController;
  final StoryEntity storyEntity;
  final int currentStoryIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomScrollableTextField(
            textFieldScrollController: textFieldScrollController,
            textController: textController,
            borderWidth: 0,
            hintText: "Reply..",
          ),
        ),
        const HorizontalGap(16),
        CustomReactStoryButton(
          story: storyEntity,
          currentStoryIndex: currentStoryIndex,
        ),
      ],
    );
  }
}
