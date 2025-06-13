part of 'react_story_cubit.dart';

abstract class ReactStoryState {}

final class ReactStoryInitial extends ReactStoryState {}

final class ReactStoryLoadingState extends ReactStoryState {}

final class ReactStoryLoadedState extends ReactStoryState {
  final StoryEntity updatedStory;
  final int currentStoryIndex;

  ReactStoryLoadedState({
    required this.updatedStory,
    required this.currentStoryIndex,
  });
}

final class ReactStoryFailureState extends ReactStoryState {
  final String message;
  ReactStoryFailureState({required this.message});
}
