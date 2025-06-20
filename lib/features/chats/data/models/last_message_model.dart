import 'package:whatsapp/features/chats/domain/entities/last_message_entity.dart';

class LastMessageModel extends LastMessageEntity {
  const LastMessageModel({
    required super.content,
    required super.status,
    required super.createdAt,
    required super.type,
    required super.senderId,
    required super.isMine,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      content: json['content'] ?? '',
      status: json['status'] ?? 'sent',
      createdAt: DateTime.parse(json['createdAt']),
      type: json['type'] ?? 'text',
      senderId: json['senderId'],
      isMine: json['isMine'] ?? false,
    );
  }

  factory LastMessageModel.fromEntity(LastMessageEntity entity) {
    return LastMessageModel(
      content: entity.content,
      status: entity.status,
      createdAt: entity.createdAt,
      type: entity.type,
      senderId: entity.senderId,
      isMine: entity.isMine,
    );
  }

  LastMessageEntity toEntity() {
    return LastMessageEntity(
      content: content,
      status: status,
      createdAt: createdAt,
      type: type,
      senderId: senderId,
      isMine: isMine,
    );
  }
}
