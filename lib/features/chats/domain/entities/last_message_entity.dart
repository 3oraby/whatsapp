import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/enums/message_type.dart';

class LastMessageEntity {
  final String? content;
  final MessageStatus messageStatus;
  final DateTime createdAt;
  final MessageType type;
  final int senderId;
  final bool isMine;

  const LastMessageEntity({
    this.content,
    required this.messageStatus,
    required this.createdAt,
    required this.type,
    required this.senderId,
    required this.isMine,
  });

  LastMessageEntity copyWith({
    String? content,
    MessageStatus? messageStatus,
    DateTime? createdAt,
    MessageType? type,
    int? senderId,
    bool? isMine,
  }) {
    return LastMessageEntity(
      content: content ?? this.content,
      messageStatus: messageStatus ?? this.messageStatus,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      senderId: senderId ?? this.senderId,
      isMine: isMine ?? this.isMine,
    );
  }
}
