import 'package:whatsapp/features/chats/domain/enums/message_react.dart';

class MessageReactionEntity {
  final int messageId;
  final MessageReact react;
  final int userId;

  const MessageReactionEntity({
    required this.messageId,
    required this.react,
    required this.userId,
  });
}
