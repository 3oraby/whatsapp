part of 'create_new_chat_cubit.dart';

abstract class CreateNewChatState {}

class CreateNewChatInitial extends CreateNewChatState {}

class CreateNewChatLoadingState extends CreateNewChatState {}

class CreateNewChatLoadedState extends CreateNewChatState {
  final ChatEntity chat;

  CreateNewChatLoadedState({required this.chat});
}

class CreateNewChatFailureState extends CreateNewChatState {
  final String message;

  CreateNewChatFailureState({required this.message});
}
