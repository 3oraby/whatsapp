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
