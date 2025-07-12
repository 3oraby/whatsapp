import 'package:whatsapp/features/chats/domain/enums/message_react.dart';

class MessageReactionEvent {
  final int messageId;
  final MessageReact react;
  final int userId;

  const MessageReactionEvent({
    required this.messageId,
    required this.react,
    required this.userId,
  });
}
