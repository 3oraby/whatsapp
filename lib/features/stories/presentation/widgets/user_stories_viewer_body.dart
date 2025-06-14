import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/cubits/react_story/react_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/contact_stories_viewer.dart';

class UserStoriesViewerBody extends StatefulWidget {
  const UserStoriesViewerBody({
    super.key,
    required this.showCurrentUserStories,
  });

  final bool showCurrentUserStories;

  @override
  State<UserStoriesViewerBody> createState() => _UserStoriesViewerBodyState();
}

class _UserStoriesViewerBodyState extends State<UserStoriesViewerBody>
    with SingleTickerProviderStateMixin {
  late PageController _outerPageController;
  late int initialIndex;
  late GetCurrentStoriesCubit getCurrentStoriesCubit;
  late List<ContactStoryEntity?> contactsStories;
  late String key;
  int currentContactIndex = 0;

  @override
  void initState() {
    super.initState();

    getCurrentStoriesCubit = BlocProvider.of<GetCurrentStoriesCubit>(context);

    if (widget.showCurrentUserStories) {
      initialIndex = 0;
      contactsStories = [getCurrentStoriesCubit.currentUserContactStoryEntity];
    } else {
      final userContactsStories = getCurrentStoriesCubit.userContactsStories;

      key = userContactsStories.getCurrentStories(
        selectedContactStory: getCurrentStoriesCubit.selectedContactStoryEntity,
      );

      if (key == "viewedContacts") {
        contactsStories = userContactsStories.viewedContacts;
      } else if (key == "unViewedContacts") {
        contactsStories = userContactsStories.unViewedContacts;
      } else {
        contactsStories = [];
      }

      initialIndex = contactsStories.indexWhere(
        (contactStoryEntity) =>
            contactStoryEntity?.contactId ==
            getCurrentStoriesCubit.selectedContactStoryEntity.contactId,
      );

      if (initialIndex == -1) initialIndex = 0;
    }

    _outerPageController = PageController(initialPage: initialIndex);
    currentContactIndex = initialIndex;

    _outerPageController.addListener(() {
      final newIndex = _outerPageController.page?.round() ?? 0;
      if (newIndex != currentContactIndex) {
        setState(() {
          currentContactIndex = newIndex;
        });
      }
    });
  }

  void updateStoryReaction({
    required int contactIndex,
    required int storyIndex,
    required bool isReacted,
  }) {
    if (contactIndex >= contactsStories.length || contactIndex < 0) return;

    final oldContact = contactsStories[contactIndex];
    if (oldContact == null || storyIndex >= oldContact.stories.length) return;

    setState(() {
      final updatedStories = List<StoryEntity>.from(oldContact.stories);
      final oldStory = updatedStories[storyIndex];
      updatedStories[storyIndex] = oldStory.copyWith(isReacted: isReacted);

      contactsStories[contactIndex] =
          oldContact.copyWith(stories: updatedStories);
    });
  }

  @override
  void dispose() {
    _outerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReactStoryCubit, ReactStoryState>(
      listener: (context, state) {
        if (state is ReactStoryLoadedState) {
          updateStoryReaction(
            contactIndex: currentContactIndex,
            storyIndex: state.currentStoryIndex,
            isReacted: state.updatedStory.isReacted ?? false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.createStoryBackgroundColor,
        body: PageView.builder(
          controller: _outerPageController,
          itemCount: contactsStories.length,
          itemBuilder: (context, contactIndex) {
            final contact = contactsStories[contactIndex];

            if (contact != null) {
              return ContactStoriesViewer(
                contactStory: contact,
                showCurrentUserStories: widget.showCurrentUserStories,
                showUnviewedStories:
                    !widget.showCurrentUserStories && key == "unViewedContacts",
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
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
