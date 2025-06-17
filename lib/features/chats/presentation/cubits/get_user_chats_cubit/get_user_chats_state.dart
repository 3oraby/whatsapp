part of 'get_user_chats_cubit.dart';

abstract class GetUserChatsState {}

final class GetUserChatsInitial extends GetUserChatsState {}

final class GetUserChatsLoadingState extends GetUserChatsState {}

final class GetUserChatsEmptyState extends GetUserChatsState {}

final class GetUserChatsLoadedState extends GetUserChatsState {
  final List<ChatEntity> chats;

  GetUserChatsLoadedState({required this.chats});
}

final class GetUserChatsFailureState extends GetUserChatsState {
  final String message;

  GetUserChatsFailureState({required this.message});
}
