part of 'get_current_stories_cubit.dart';


abstract class GetCurrentStoriesState {}

final class GetCurrentStoriesInitial extends GetCurrentStoriesState {}

final class GetCurrentStoriesLoadingState extends GetCurrentStoriesState {}

final class GetCurrentStoriesLoadedState extends GetCurrentStoriesState {
  final List<StoryEntity> currentUserStories;
  final UserContactsStoryEntity userContactsStories;
  GetCurrentStoriesLoadedState
  (
    {required this.currentUserStories,required this.userContactsStories}
  );
}

final class GetCurrentStoriesFailureState extends GetCurrentStoriesState {
  final String message;
  GetCurrentStoriesFailureState({required this.message});
}
