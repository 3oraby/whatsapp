import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/user_contacts_story_entity.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';

part 'get_current_stories_state.dart';

class GetCurrentStoriesCubit extends BaseCubit<GetCurrentStoriesState> {
  GetCurrentStoriesCubit({required this.storiesRepo})
      : super(GetCurrentStoriesInitial());

  final StoriesRepo storiesRepo;

  Future<void> getCurrentStories() async {
    emit(GetCurrentStoriesLoadingState());

    try {
      final results = await Future.wait([
        storiesRepo.getCurrentUserStory(),
        storiesRepo.getUserContactsStory(),
      ]);

      final userStoriesResult =
          results[0] as Either<Failure, List<StoryEntity>>;
      final contactsStoriesResult =
          results[1] as Either<Failure, UserContactsStoryEntity>;

      if (userStoriesResult.isLeft()) {
        final failure = userStoriesResult.fold((f) => f, (_) => null);
        handleFailure(failure!);
        emit(GetCurrentStoriesFailureState(message: failure.message!));
        return;
      }

      if (contactsStoriesResult.isLeft()) {
        final failure = contactsStoriesResult.fold((f) => f, (_) => null);
        handleFailure(failure!);
        emit(GetCurrentStoriesFailureState(message: failure.message!));
        return;
      }

      final currentUserStories = userStoriesResult.getOrElse(() => []);
      final contactsStories = contactsStoriesResult
          .getOrElse(() => UserContactsStoryEntity.empty());

      emit(GetCurrentStoriesLoadedState(
        currentUserStories: currentUserStories,
        userContactsStories: contactsStories,
      ));
    } catch (e) {
      emit(GetCurrentStoriesFailureState(message: e.toString()));
    }
  }
}
