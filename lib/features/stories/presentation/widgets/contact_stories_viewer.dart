import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/time_ago_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/core/utils/app_text_styles.dart';
import 'package:whatsapp/core/widgets/build_user_profile_image.dart';
import 'package:whatsapp/core/widgets/custom_app_padding.dart';
import 'package:whatsapp/core/widgets/custom_background_icon.dart';
import 'package:whatsapp/core/widgets/custom_scrollable_text_field.dart';
import 'package:whatsapp/core/widgets/horizontal_gap.dart';
import 'package:whatsapp/core/widgets/leading_arrow_back.dart';
import 'package:whatsapp/core/widgets/vertical_gap.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/view_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_content_overlay.dart';
import 'package:whatsapp/features/stories/presentation/widgets/story_progress_bar_segment.dart';

class ContactStoriesViewer extends StatefulWidget {
  final ContactStoryEntity contactStory;
  final VoidCallback onContactFinished;
  final int initialIndex;
  final bool showCurrentUserStories;

  const ContactStoriesViewer({
    super.key,
    required this.contactStory,
    required this.onContactFinished,
    required this.initialIndex,
    required this.showCurrentUserStories,
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
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    _storyProgressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _storyProgressController.addStatusListener((status) {
      markStoryAsViewed();
      if (status == AnimationStatus.completed) {
        _goToNextStory();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _storyProgressController.forward();
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
    if (!widget.showCurrentUserStories) {
      getCurrentStoriesCubit.markStoryAsViewed(
        contactStoryEntity: widget.contactStory,
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
                  Row(
                    children: List.generate(
                      widget.contactStory.stories.length,
                      (index) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: StoryProgressBarSegment(
                              isSeen: index < _currentIndex,
                              isCurrent: index == _currentIndex,
                              controller: _storyProgressController,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const VerticalGap(16),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.contactStory.stories.length,
                      itemBuilder: (context, index) {
                        final story = widget.contactStory.stories[index];
                        final hasImage = story.mediaUrl != null;
                        final hasText = story.content != null;

                        return Column(
                          children: [
                            Row(
                              children: [
                                LeadingArrowBack(color: Colors.white),
                                const HorizontalGap(12),
                                BuildUserProfileImage(
                                  circleAvatarRadius: 20,
                                  profilePicUrl:
                                      widget.contactStory.profileImage,
                                ),
                                const HorizontalGap(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.contactStory.name,
                                      style: AppTextStyles.poppinsMedium(
                                              context, 16)
                                          .copyWith(color: Colors.white),
                                    ),
                                    Text(
                                      TimeAgoService.formatTimeForDisplay(
                                          story.createdAt),
                                      style: AppTextStyles.poppinsRegular(
                                              context, 14)
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const VerticalGap(16),
                            if (hasImage)
                              Expanded(
                                child: CachedNetworkImage(
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: story.mediaUrl!,
                                ),
                              ),
                            if (hasText && !hasImage)
                              Expanded(
                                child: StoryContentOverlay(
                                  text: story.content!,
                                  alignAtBottom: hasImage,
                                ),
                              )
                            else if (hasText)
                              StoryContentOverlay(
                                text: story.content!,
                                alignAtBottom: hasImage,
                              ),
                            const Divider(),
                            const VerticalGap(12),
                            if (widget.showCurrentUserStories)
                              ShowCurrentUserStoryViews(
                                views:
                                    widget.contactStory.stories[index].views ??
                                        [],
                                onBottomSheetOpened: () {
                                  _storyProgressController.stop();
                                },
                                onBottomSheetClosed: () {
                                  _storyProgressController.forward();
                                },
                              ),
                            if (!widget.showCurrentUserStories)
                              StoryInteractionPart(
                                textFieldScrollController:
                                    textFieldScrollController,
                                textController: textController,
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

class ShowCurrentUserStoryViews extends StatelessWidget {
  const ShowCurrentUserStoryViews({
    super.key,
    required this.views,
    required this.onBottomSheetOpened,
    required this.onBottomSheetClosed,
  });

  final List<ViewStoryEntity> views;
  final VoidCallback onBottomSheetOpened;
  final VoidCallback onBottomSheetClosed;

  void _showViewersBottomSheet(BuildContext context) {
    onBottomSheetOpened();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (_) {
        return CustomAppPadding(
          child: Column(
            children: [
              const VerticalGap(16),
              Container(
                height: 6,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const VerticalGap(8),
              Row(
                children: [
                  Text(
                    "${views.length} views",
                    style: AppTextStyles.poppinsMedium(context, 18),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: views.length,
                  separatorBuilder: (context, index) =>
                      const VerticalGap(4),
                  itemBuilder: (context, index) {
                    final view = views[index];
                    return Row(
                      children: [
                        BuildUserProfileImage(
                          circleAvatarRadius: 22,
                          profilePicUrl: view.user.profileImage,
                        ),
                        const HorizontalGap(12),
                        Expanded(
                          child: Column(
                            children: [
                              const VerticalGap(12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    view.user.name,
                                    style:
                                        AppTextStyles.poppinsMedium(context, 18),
                                  ),
                                  Text(
                                    TimeAgoService.formatForStoryViewers(
                                        view.createdAt),
                                    style:
                                        AppTextStyles.poppinsMedium(context, 14),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      onBottomSheetClosed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showViewersBottomSheet(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.expand_less, size: 32, color: Colors.white),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.remove_red_eye, size: 22, color: Colors.white),
              const HorizontalGap(4),
              Text(
                views.length.toString(),
                style: AppTextStyles.poppinsBold(context, 14).copyWith(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class StoryInteractionPart extends StatelessWidget {
  const StoryInteractionPart({
    super.key,
    required this.textFieldScrollController,
    required this.textController,
  });

  final ScrollController textFieldScrollController;
  final TextEditingController textController;

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
        CustomBackgroundIcon(
          backgroundColor: Colors.black54,
          iconColor: Colors.white,
          iconData: Icons.favorite_border,
        )
      ],
    );
  }
}
