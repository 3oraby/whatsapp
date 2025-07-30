import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_body_content.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_footer.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_header.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_progress_indicators.dart';

class ContactStoriesViewer extends StatefulWidget {
  final ContactStoryEntity contactStory;
  final VoidCallback onContactFinished;
  final bool showCurrentUserStories;
  final bool showUnviewedStories;

  const ContactStoriesViewer({
    super.key,
    required this.contactStory,
    required this.onContactFinished,
    required this.showCurrentUserStories,
    required this.showUnviewedStories,
  });

  @override
  State<ContactStoriesViewer> createState() => _ContactStoriesViewerState();
}

class _ContactStoriesViewerState extends State<ContactStoriesViewer>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late int _currentIndex;
  double dragOffset = 0.0;
  late List<ContactStoryEntity?> contactsStories;

  late AnimationController _storyProgressController;
  final TextEditingController textController = TextEditingController();
  final ScrollController textFieldScrollController = ScrollController();
  late GetCurrentStoriesCubit getCurrentStoriesCubit;

  @override
  void initState() {
    super.initState();

    getCurrentStoriesCubit = BlocProvider.of<GetCurrentStoriesCubit>(context);
    _currentIndex = widget.contactStory.firstUnviewedStoryIndex;
    log("initial inner index : $_currentIndex");
    _pageController = PageController(initialPage: _currentIndex);

    _storyProgressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _storyProgressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToNextStory();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _storyProgressController.forward();
      markStoryAsViewed();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _storyProgressController.dispose();
    super.dispose();
  }

  void _goToNextStory() {
    if (_currentIndex < widget.contactStory.stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _storyProgressController.forward(from: 0.0);

      markStoryAsViewed();
    } else {
      widget.onContactFinished();
    }
  }

  void markStoryAsViewed() {
    if (widget.showUnviewedStories) {
      log("mark story as viewed : : : ${widget.contactStory.stories[_currentIndex].id}");
      getCurrentStoriesCubit.markStoryAsViewed(
        contactId: widget.contactStory.contactId,
        storyId: widget.contactStory.stories[_currentIndex].id,
      );
    }
  }

  void _goToPreviousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _storyProgressController.forward(from: 0.0);
    }
  }

  void _onTapDown(TapDownDetails details, BoxConstraints constraints) {
    final dx = details.globalPosition.dx;
    if (dx < constraints.maxWidth / 2) {
      _goToPreviousStory();
    } else {
      _goToNextStory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.createStoryBackgroundColor,
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => _onTapDown(details, constraints),
          onLongPress: () {
            _storyProgressController.stop();
          },
          onLongPressUp: () {
            _storyProgressController.forward();
          },
          onVerticalDragUpdate: (details) {
            dragOffset += details.delta.dy;
          },
          onVerticalDragEnd: (details) {
            if (dragOffset > 100) {
              Navigator.pop(context);
            }
            dragOffset = 0.0;
          },
          child: CustomAppPadding(
            vertical: 0,
            child: SafeArea(
              child: Column(
                children: [
                  StoryProgressIndicators(
                    currentIndex: _currentIndex,
                    totalStories: widget.contactStory.stories.length,
                    controller: _storyProgressController,
                  ),
                  const VerticalGap(16),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.contactStory.stories.length,
                      itemBuilder: (context, index) {
                        final story = widget.contactStory.stories[index];

                        return Column(
                          children: [
                            StoryHeader(
                              name: widget.contactStory.name,
                              profileImage: widget.contactStory.profileImage,
                              createdAt: story.createdAt,
                              isCurrentUser: widget.showCurrentUserStories,
                            ),
                            const VerticalGap(16),
                            StoryBodyContent(
                              mediaUrl: story.mediaUrl,
                              content: story.content,
                            ),
                            const Divider(),
                            const VerticalGap(12),
                            StoryFooter(
                              showCurrentUserStories:
                                  widget.showCurrentUserStories,
                              storyEntity: story,
                              textController: textController,
                              scrollController: textFieldScrollController,
                              onSheetOpened: () =>
                                  _storyProgressController.stop(),
                              onSheetClosed: () =>
                                  _storyProgressController.forward(),
                              currentStoryIndex: index,
                            ),
                            const VerticalGap(16),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
