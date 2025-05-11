import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';

part 'create_new_story_state.dart';

class CreateNewStoryCubit extends BaseCubit<CreateNewStoryState> {
  CreateNewStoryCubit({required this.storiesRepo})
      : super(CreateNewStoryInitial());

  final StoriesRepo storiesRepo;

  Future<void> createNewStory({required Map<String, dynamic> data}) async {
    emit(CreateNewStoryLoadingState());

    final result = await storiesRepo.createNewStory(
      data: data,
    );

    result.fold(
      (failure) {
        handleFailure(failure);
        emit(CreateNewStoryFailureState(message: failure.message!));
      },
      (story) => emit(CreateNewStoryLoadedState(
        storyEntity: story,
      )),
    );
  }
}
