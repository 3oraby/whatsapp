import 'package:dartz/dartz.dart';
import 'package:whatsapp/core/cubit/base/base_cubit.dart';
import 'package:whatsapp/core/errors/failures.dart';
import 'package:whatsapp/features/stories/domain/entities/contact_story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/story_entity.dart';
import 'package:whatsapp/features/stories/domain/entities/user_contacts_story_entity.dart';
import 'package:whatsapp/features/stories/domain/repos/stories_repo.dart';

part 'get_current_stories_state.dart';

class GetCurrentStoriesCubit extends BaseCubit<GetCurrentStoriesState> {
  GetCurrentStoriesCubit({required this.storiesRepo})
      : super(GetCurrentStoriesInitial());

  final StoriesRepo storiesRepo;

  ContactStoryEntity currentUserContactStoryEntity = ContactStoryEntity.empty();
  UserContactsStoryEntity userContactsStories = UserContactsStoryEntity.empty();
  ContactStoryEntity selectedContactStoryEntity = ContactStoryEntity.empty();

  Future<void> getCurrentStories() async {
    emit(GetCurrentStoriesLoadingState());

    try {
      final results = await Future.wait([
        storiesRepo.getCurrentUserStory(),
        storiesRepo.getUserContactsStory(),
      ]);

      final userStoriesResult =
          results[0] as Either<Failure, ContactStoryEntity>;
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

      final currentUserStories =
          userStoriesResult.getOrElse(() => ContactStoryEntity.empty());
      final contactsStories = contactsStoriesResult
          .getOrElse(() => UserContactsStoryEntity.empty());

      currentUserContactStoryEntity = currentUserStories;
      userContactsStories = contactsStories;

      emit(GetCurrentStoriesLoadedState(
        currentUserContactStoryEntity: currentUserStories,
        userContactsStories: contactsStories,
      ));
    } catch (e) {
      emit(GetCurrentStoriesFailureState(message: e.toString()));
    }
  }

  Future<void> markStoryAsViewed({
    required ContactStoryEntity contactStoryEntity,
    required int storyId,
  }) async {
    final currentState = state;
    if (currentState is GetCurrentStoriesLoadedState) {
      if (!contactStoryEntity.isStoryViewedAtIndex(storyId)) {
        final result = await storiesRepo.viewStory(storyId: storyId);
        final storyIndex = contactStoryEntity.getStoryIndexById(storyId);

        result.fold(
          (failure) {
            emit(ViewStoryFailureState(message: failure.message!));
          },
          (_) {
            final updatedStories =
                List<StoryEntity>.from(contactStoryEntity.stories);
            final oldStory = updatedStories[storyIndex];
            updatedStories[storyIndex] = oldStory.copyWith(isViewed: true);

            final updatedContactStory = contactStoryEntity.copyWith(
              stories: updatedStories,
            );

            final unViewedUpdated = List<ContactStoryEntity>.from(
                currentState.userContactsStories.unViewedContacts);
            final viewedUpdated = List<ContactStoryEntity>.from(
                currentState.userContactsStories.viewedContacts);

            final viewedIndex = viewedUpdated.indexWhere(
                (c) => c.contactId == updatedContactStory.contactId);

            if (viewedIndex != -1) {
              viewedUpdated[viewedIndex] = updatedContactStory;
            } else {
              viewedUpdated.add(updatedContactStory);
              unViewedUpdated.removeWhere(
                  (c) => c.contactId == updatedContactStory.contactId);
            }

            userContactsStories = UserContactsStoryEntity(
              viewedContacts: viewedUpdated,
              unViewedContacts: unViewedUpdated,
            );
            emit(currentState.copyWith(
              userContactsStories: userContactsStories,
            ));
          },
        );
      }
    }
  }
}
