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

class MessageDeletedSuccessfullyState extends MessageStreamState {
  final int messageId;

  MessageDeletedSuccessfullyState({
    required this.messageId,
  });
}

class MessageEditedSuccessfullyState extends MessageStreamState {
  final int messageId;
  final String newContent;
  MessageEditedSuccessfullyState({
    required this.messageId,
    required this.newContent,
  });
}

class CreateMessageReactSuccessfullyState extends MessageStreamState {
  final MessageReactionEntity messageReaction;
  
  CreateMessageReactSuccessfullyState({
    required this.messageReaction,
  });
}

class DeleteMessageReactSuccessfullyState extends MessageStreamState {
  final MessageReactionEntity messageReaction;

  DeleteMessageReactSuccessfullyState({
    required this.messageReaction,
  });
}

class EditMessageState extends MessageStreamState {
  final int messageId;
  final String newContent;

  EditMessageState({
    required this.messageId,
    required this.newContent,
  });
}

class DeleteMessageState extends MessageStreamState {
  final int messageId;

  DeleteMessageState({
    required this.messageId,
  });
}

class CreateNewReactMessageState extends MessageStreamState {
  final int messageId;
  final MessageReact reactType;

  CreateNewReactMessageState({
    required this.messageId,
    required this.reactType,
  });
}
