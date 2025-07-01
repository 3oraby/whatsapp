import 'package:whatsapp/features/chats/domain/entities/last_message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/enums/message_type.dart';

class LastMessageModel extends LastMessageEntity {
  const LastMessageModel({
    required super.messageId,
    super.content,
    required super.messageStatus,
    required super.createdAt,
    required super.type,
    required super.senderId,
    required super.isMine,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      messageId: json["messageId"],
      content: json['content'] ?? '',
      messageStatus:
          MessageStatusExtension.fromString(json['status'] ?? 'sent'),
      createdAt: DateTime.parse(json['createdAt']),
      type: MessageTypeExtension.fromString(json['type'] ?? 'text'),
      senderId: json['senderId'],
      isMine: json['isMine'] ?? false,
    );
  }

  factory LastMessageModel.fromEntity(LastMessageEntity entity) {
    return LastMessageModel(
      messageId: entity.messageId,
      content: entity.content,
      messageStatus: entity.messageStatus,
      createdAt: entity.createdAt,
      type: entity.type,
      senderId: entity.senderId,
      isMine: entity.isMine,
    );
  }

  LastMessageEntity toEntity() {
    return LastMessageEntity(
      messageId: messageId,
      content: content,
      messageStatus: messageStatus,
      createdAt: createdAt,
      type: type,
      senderId: senderId,
      isMine: isMine,
    );
  }
}
