import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/enums/message_type.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';

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
    required super.isFromMe,
    required super.reactsCount,
    super.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      content: json['content'],
      mediaUrl: json['media_url'],
      chatId: json['chat_id'],
      senderId: json['user_id'],
      receiverId: json['reciever_id'],
      status: MessageStatusExtension.fromString(json['status'] ?? 'sent'),
      parentId: json['parent']?['id'],
      type: MessageTypeExtension.fromString(json['type'] ?? 'text'),
      statusId: json['statusId'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isFromMe: json['isFromMe'] ?? false,
      reactsCount: json['reacts_count'] ?? 0,
      sender: json['user'] != null
          ? UserModel.fromJson(json['user']).toEntity()
          : null,
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
      isFromMe: entity.isFromMe,
      reactsCount: entity.reactsCount,
      sender: entity.sender,
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
      isFromMe: isFromMe,
      reactsCount: reactsCount,
      sender: sender,
    );
  }
}
