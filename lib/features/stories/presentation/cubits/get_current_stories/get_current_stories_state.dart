part of 'get_current_stories_cubit.dart';

abstract class GetCurrentStoriesState {}

final class GetCurrentStoriesInitial extends GetCurrentStoriesState {}

final class GetCurrentStoriesLoadingState extends GetCurrentStoriesState {}

final class GetCurrentStoriesLoadedState extends GetCurrentStoriesState {
  final ContactStoryEntity currentUserContactStoryEntity;
  final UserContactsStoryEntity userContactsStories;
  GetCurrentStoriesLoadedState({
    required this.currentUserContactStoryEntity,
    required this.userContactsStories,
  });

  GetCurrentStoriesLoadedState copyWith({
    ContactStoryEntity? currentUserContactStoryEntity,
    UserContactsStoryEntity? userContactsStories,
  }) {
    return GetCurrentStoriesLoadedState(
      currentUserContactStoryEntity:
          currentUserContactStoryEntity ?? this.currentUserContactStoryEntity,
      userContactsStories: userContactsStories ?? this.userContactsStories,
    );
  }
}

final class GetCurrentStoriesFailureState extends GetCurrentStoriesState {
  final String message;
  GetCurrentStoriesFailureState({required this.message});
}


final class ViewStoryFailureState extends GetCurrentStoriesState {
  final String message;
  ViewStoryFailureState({required this.message});
}
