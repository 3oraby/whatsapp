import 'package:flutter/widgets.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_progress_bar_segment.dart';

class StoryProgressIndicators extends StatelessWidget {
  final int currentIndex;
  final int totalStories;
  final AnimationController controller;

  const StoryProgressIndicators({
    super.key,
    required this.currentIndex,
    required this.totalStories,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalStories,
        (index) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: StoryProgressBarSegment(
              isSeen: index < currentIndex,
              isCurrent: index == currentIndex,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }
}
