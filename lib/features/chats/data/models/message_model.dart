import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.content,
    super.mediaUrl,
    super.chatId,
    required super.senderId,
    required super.receiverId,
    required super.status,
    super.parentId,
    required super.type,
    super.statusId,
    super.isDeleted,
    required super.createdAt,
    super.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      content: json['content'],
      mediaUrl: json['media_url'],
      chatId: json['chat_id'],
      senderId: json['user_id'],
      receiverId: json['reciever_id'],
      status: json['status'],
      parentId: json['parent_id'],
      type: json['type'],
      statusId: json['statusId'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      content: entity.content,
      mediaUrl: entity.mediaUrl,
      chatId: entity.chatId,
      senderId: entity.senderId,
      receiverId: entity.receiverId,
      status: entity.status,
      parentId: entity.parentId,
      type: entity.type,
      statusId: entity.statusId,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      content: content,
      mediaUrl: mediaUrl,
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      status: status,
      parentId: parentId,
      type: type,
      statusId: statusId,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
