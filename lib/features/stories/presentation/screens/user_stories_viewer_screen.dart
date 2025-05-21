import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';

class UserStoriesViewerScreen extends StatefulWidget {
  const UserStoriesViewerScreen({
    super.key,
    this.showCurrentUserStories = true,
  });

  final bool showCurrentUserStories;

  @override
  State<UserStoriesViewerScreen> createState() =>
      _UserStoriesViewerScreenState();
}

class _UserStoriesViewerScreenState extends State<UserStoriesViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _outerPageController;
  late int initialIndex;
  late GetCurrentStoriesCubit getCurrentStoriesCubit;
  late List<ContactStoryEntity?> contactsStories;

  @override
  void initState() {
    super.initState();

    getCurrentStoriesCubit = BlocProvider.of<GetCurrentStoriesCubit>(context);

    if (widget.showCurrentUserStories) {
      initialIndex = 0;
      contactsStories = [getCurrentStoriesCubit.currentUserContactStoryEntity];
    } else {
      final userContactsStories = getCurrentStoriesCubit.userContactsStories;
      initialIndex = getCurrentStoriesCubit
          .selectedContactStoryEntity.firstUnviewedStoryIndex;
      contactsStories = userContactsStories.getCurrentStoriesList(
        selectedContactStory: getCurrentStoriesCubit.selectedContactStoryEntity,
      );
    }

    _outerPageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _outerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.createStoryBackgroundColor,
      body: PageView.builder(
        controller: _outerPageController,
        itemCount: contactsStories.length,
        itemBuilder: (context, contactIndex) {
          final contact = contactsStories[contactIndex];

          if (contact != null) {
            return ContactStoriesViewer(
              contactStory: contact,
              initialIndex: initialIndex,
              onContactFinished: () {
                if (contactIndex < contactsStories.length - 1) {
                  _outerPageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class StorySegment extends StatelessWidget {
  final bool isSeen;
  final bool isCurrent;
  final AnimationController? controller;

  const StorySegment({
    super.key,
    required this.isSeen,
    required this.isCurrent,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller ?? AlwaysStoppedAnimation(0.0),
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: isSeen
                ? 1.0
                : isCurrent
                    ? controller?.value ?? 0.0
                    : 0.0,
            backgroundColor: Colors.white30,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class ContactStoriesViewer extends StatefulWidget {
  final ContactStoryEntity contactStory;
  final VoidCallback onContactFinished;
  final int initialIndex;

  const ContactStoriesViewer({
    super.key,
    required this.contactStory,
    required this.onContactFinished,
    required this.initialIndex,
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

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;
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
    } else {
      widget.onContactFinished();
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
                            child: StorySegment(
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
                      itemBuilder: (context, index) => Column(
                        children: [
                          Row(
                            children: [
                              LeadingArrowBack(
                                color: Colors.white,
                              ),
                              const HorizontalGap(12),
                              BuildUserProfileImage(
                                circleAvatarRadius: 20,
                                profilePicUrl: widget.contactStory.profileImage,
                              ),
                              const HorizontalGap(16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "oraby",
                                    style:
                                        AppTextStyles.poppinsMedium(context, 16)
                                            .copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "yesterday",
                                    // "TimeAgoService.formatTimeForDisplay(dateTime)",
                                    style: AppTextStyles.poppinsRegular(
                                            context, 14)
                                        .copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const VerticalGap(16),
                          if (widget.contactStory.stories[index].mediaUrl !=
                              null)
                            Expanded(
                              child: CachedNetworkImage(
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: widget
                                    .contactStory.stories[index].mediaUrl!,
                              ),
                            ),
                          if (widget.contactStory.stories[index].content !=
                              null)
                            Column(
                              children: [
                                const VerticalGap(16),
                                Text(
                                  widget.contactStory.stories[index].content!,
                                  style:
                                      AppTextStyles.poppinsMedium(context, 16)
                                          .copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  const VerticalGap(12),
                  Row(
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
                  ),
                  const VerticalGap(16),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
