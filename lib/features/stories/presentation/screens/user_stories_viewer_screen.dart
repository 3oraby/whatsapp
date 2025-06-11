import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/utils/app_colors.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';
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
          return SizedBox();
        },
      ),
    );
  }
}
