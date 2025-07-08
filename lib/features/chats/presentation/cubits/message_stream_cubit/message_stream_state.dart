part of 'message_stream_cubit.dart';

abstract class MessageStreamState {}

class MessageStreamInitial extends MessageStreamState {}

class NewIncomingMessageState extends MessageStreamState {
  final MessageEntity message;

  NewIncomingMessageState(this.message);
}

class NewOutgoingMessageState extends MessageStreamState {
  final MessageEntity message;

  NewOutgoingMessageState(this.message);
}

class UpdateMessageStatusState extends MessageStreamState {
  final int chatId;
  final int newId;
  final MessageStatus newStatus;
  UpdateMessageStatusState({
    required this.chatId,
    required this.newId,
    required this.newStatus,
  });
}

class AllMessagesReadState extends MessageStreamState {
  final int chatId;

  AllMessagesReadState({required this.chatId});
}

class UserTypingState extends MessageStreamState {
  final int chatId;
  final int senderId;

  UserTypingState({
    required this.chatId,
    required this.senderId,
  });
}

class UserStopTypingState extends MessageStreamState {
  final int chatId;
  final int senderId;

  UserStopTypingState({
    required this.chatId,
    required this.senderId,
  });
}
