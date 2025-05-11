part of 'create_new_story_cubit.dart';

abstract class CreateNewStoryState {}

final class CreateNewStoryInitial extends CreateNewStoryState {}

final class CreateNewStoryLoadingState extends CreateNewStoryState {}

final class CreateNewStoryLoadedState extends CreateNewStoryState {
  final StoryEntity storyEntity;

  CreateNewStoryLoadedState({required this.storyEntity});
}

final class CreateNewStoryFailureState extends CreateNewStoryState {
  final String message;
  CreateNewStoryFailureState({required this.message});
}
