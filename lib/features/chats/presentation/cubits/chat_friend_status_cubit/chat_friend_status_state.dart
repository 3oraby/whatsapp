part of 'chat_friend_status_cubit.dart';

abstract class ChatFriendStatusState {}

class ChatFriendStatusInitial extends ChatFriendStatusState {}

class ChatFriendStatusUpdated extends ChatFriendStatusState {
  final bool isOnline;
  final DateTime lastSeen;

  ChatFriendStatusUpdated({
    required this.isOnline,
    required this.lastSeen,
  });
}
