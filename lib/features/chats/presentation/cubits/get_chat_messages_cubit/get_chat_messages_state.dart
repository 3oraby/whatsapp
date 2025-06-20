part of 'get_chat_messages_cubit.dart';

abstract class GetChatMessagesState {}

class GetChatMessagesInitial extends GetChatMessagesState {}

class GetChatMessagesLoadingState extends GetChatMessagesState {}

class GetChatMessagesEmptyState extends GetChatMessagesState {}

class GetChatMessagesLoadedState extends GetChatMessagesState {
  final List<MessageEntity> messages;

  GetChatMessagesLoadedState({required this.messages});
}

class GetChatMessagesFailureState extends GetChatMessagesState {
  final String message;

  GetChatMessagesFailureState({required this.message});
}
