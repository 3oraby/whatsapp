import 'package:whatsapp/features/chats/data/models/message_reaction_info_model.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/enums/message_type.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.content,
    required super.senderId,
    required super.receiverId,
    required super.status,
    required super.type,
    required super.createdAt,
    required super.isFromMe,
    required super.reactsCount,
    super.mediaUrl,
    super.chatId,
    super.parentId,
    super.statusId,
    super.isDeleted,
    super.isEdited,
    super.updatedAt,
    super.sender,
    super.reacts = const [],
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
      isEdited: json['isUpdated'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isFromMe: json['isFromMe'] ?? false,
      reactsCount: json['reacts_count'] ?? 0,
      sender: json['user'] != null
          ? UserModel.fromJson(json['user']).toEntity()
          : null,
      reacts: (json['reacts'] as List<dynamic>?)
              ?.map((e) => MessageReactionInfoModel.fromJson(e).toEntity())
              .toList() ??
          [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'media_url': mediaUrl,
      'chat_id': chatId,
      'user_id': senderId,
      'reciever_id': receiverId,
      'status': status.name,
      'parent_id': parentId,
      'type': type.name,
      'statusId': statusId,
      'isDeleted': isDeleted,
      'isUpdated': isEdited,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isFromMe': isFromMe,
      'reacts_count': reactsCount,
      'user': sender != null ? UserModel.fromEntity(sender!).toJson() : null,
      'reacts': reacts
          .map((r) => MessageReactionInfoModel.fromEntity(r).toJson())
          .toList(),
    };
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
      isEdited: entity.isEdited,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isFromMe: entity.isFromMe,
      reactsCount: entity.reactsCount,
      sender: entity.sender,
      reacts: entity.reacts,
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
      isEdited: isEdited,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isFromMe: isFromMe,
      reactsCount: reactsCount,
      sender: sender,
      reacts: reacts,
    );
  }
}
