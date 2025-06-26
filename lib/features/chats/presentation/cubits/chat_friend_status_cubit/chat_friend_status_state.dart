part of 'chat_friend_status_cubit.dart';

abstract class ChatFriendStatusState {}

class ChatFriendStatusInitial extends ChatFriendStatusState {}

class ChatFriendStatusUpdated extends ChatFriendStatusState {
  final UserCurrentStatusEntity status;

  ChatFriendStatusUpdated(this.status);
}
