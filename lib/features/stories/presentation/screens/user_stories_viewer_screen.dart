import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
import 'package:whatsapp/features/stories/presentation/cubits/react_story/react_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/contact_stories_viewer.dart';

class UserStoriesViewerScreen extends StatefulWidget {
  const UserStoriesViewerScreen({
    super.key,
    required this.showCurrentUserStories,
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
    }
    log('initial outer index: $initialIndex');

    _outerPageController = PageController(initialPage: initialIndex);
  }

  void updateStoryReaction({
    required int contactIndex,
    required int storyIndex,
    required bool isReacted,
  }) {
    setState(() {
      final oldContact = contactsStories[contactIndex];
      if (oldContact == null) return;

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
    return BlocProvider(
      create: (context) => ReactStoryCubit(
        storiesRepo: getIt<StoriesRepo>(),
      ),
      child: Builder(builder: (context) {
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
                currentContactIndex = contactIndex;

                if (contact != null) {
                  return ContactStoriesViewer(
                    contactStory: contact,
                    showCurrentUserStories: widget.showCurrentUserStories,
                    showUnviewedStories: !widget.showCurrentUserStories &&
                        key == "unViewedContacts",
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
          ),
        );
      }),
    );
  }
}
