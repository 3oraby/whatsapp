
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';
import 'package:whatsapp/features/stories/presentation/cubits/react_story/react_story_cubit.dart';
import 'package:whatsapp/features/stories/presentation/widgets/user_stories_viewer_body.dart';

class UserStoriesViewerScreen extends StatelessWidget {
  const UserStoriesViewerScreen({
    super.key,
    required this.showCurrentUserStories,
  });

  final bool showCurrentUserStories;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReactStoryCubit(
        storiesRepo: getIt<StoriesRepo>(),
      ),
      child: UserStoriesViewerBody(
        showCurrentUserStories: showCurrentUserStories,
      ),
    );
  }
}
