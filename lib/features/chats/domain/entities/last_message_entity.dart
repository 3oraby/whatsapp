import 'package:whatsapp/features/chats/domain/enums/message_status.dart';

class LastMessageEntity {
  final String content;
  final MessageStatus messageStatus;
  final DateTime createdAt;
  final String type;
  final int senderId;
  final bool isMine;

  const LastMessageEntity({
    required this.content,
    required this.messageStatus,
    required this.createdAt,
    required this.type,
    required this.senderId,
    required this.isMine,
  });
}
