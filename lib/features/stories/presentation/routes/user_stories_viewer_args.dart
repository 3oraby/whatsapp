import 'package:whatsapp/features/stories/presentation/cubits/get_current_stories/get_current_stories_cubit.dart';

class UserStoriesViewerArgs {
  final GetCurrentStoriesCubit cubit;
  final bool showCurrentUserStories;

  const UserStoriesViewerArgs({
    required this.cubit,
    this.showCurrentUserStories = false,
  });
}
