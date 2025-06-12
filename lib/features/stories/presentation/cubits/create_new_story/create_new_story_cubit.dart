import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/features/stories/data/models/create_story_request_model.dart';
import 'package:whatsapp/features/stories/domain/entities/create_story_request_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';

part 'create_new_story_state.dart';

class CreateNewStoryCubit extends BaseCubit<CreateNewStoryState> {
  CreateNewStoryCubit({required this.storiesRepo})
      : super(CreateNewStoryInitial());

  final StoriesRepo storiesRepo;
  CreateStoryRequestEntity createStoryRequestEntity =
      CreateStoryRequestEntity();

  Future<void> createNewStory() async {
    emit(CreateNewStoryLoadingState());

    final storyModel = createStoryRequestEntity;
    createStoryRequestEntity = CreateStoryRequestEntity();
    final result = await storiesRepo.createNewStory(
      data: CreateStoryRequestModel.fromEntity(storyModel).toJson(),
    );

    result.fold((failure) {
      handleFailure(failure);
      emit(CreateNewStoryFailureState(message: failure.message!));
    }, (story) {
      emit(CreateNewStoryLoadedState(
        storyEntity: story,
      ));
    });
  }
}
