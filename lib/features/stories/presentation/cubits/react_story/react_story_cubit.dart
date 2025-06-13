import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';

part 'react_story_state.dart';

class ReactStoryCubit extends BaseCubit<ReactStoryState> {
  ReactStoryCubit({
    required this.storiesRepo,
  }) : super(ReactStoryInitial());

  final StoriesRepo storiesRepo;

  Future<void> reactStory({
    required StoryEntity story,
    required int currentStoryIndex,
  }) async {
    emit(
      ReactStoryLoadedState(
        updatedStory: story.copyWith(
          isReacted: !(story.isReacted ?? false),
        ),
        currentStoryIndex: currentStoryIndex,
      ),
    );
    final result = await storiesRepo.reactStory(
      storyId: story.id,
    );

    result.fold((failure) {
      handleFailure(failure);
      emit(ReactStoryFailureState(message: failure.message!));
    }, (story) {});
  }
}
