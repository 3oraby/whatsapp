part of 'get_current_stories_cubit.dart';

abstract class GetCurrentStoriesState {}

final class GetCurrentStoriesInitial extends GetCurrentStoriesState {}

final class GetCurrentStoriesLoadingState extends GetCurrentStoriesState {}

final class GetCurrentStoriesLoadedState extends GetCurrentStoriesState {
  final ContactStoryEntity currentUserContactStoryEntity;
  final UserContactsStoryEntity userContactsStories;
  GetCurrentStoriesLoadedState(
      {required this.currentUserContactStoryEntity,
      required this.userContactsStories});
}

final class GetCurrentStoriesFailureState extends GetCurrentStoriesState {
  final String message;
  GetCurrentStoriesFailureState({required this.message});
}
