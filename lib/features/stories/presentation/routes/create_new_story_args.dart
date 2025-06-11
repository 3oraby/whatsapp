import 'package:whatsapp/features/stories/presentation/cubits/create_new_story/create_new_story_cubit.dart';

class CreateNewStoryArgs {
  final CreateNewStoryCubit cubit;
  final int initialTab;

  CreateNewStoryArgs({
    required this.cubit,
    required this.initialTab,
  });
}
