import 'dart:developer';

import 'package:whatsapp/features/chats/data/models/last_message_model.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.anotherUser,
    required super.isPinned,
    required super.isFavorite,
    required super.lastMessage,
    required super.unreadCount,
    super.pinnedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    try {
      final participantJson = (json['participants'] as List).first;

      return ChatModel(
        id: json['chatId'] ?? json['id'],
        anotherUser: UserModel.fromJson(participantJson).toEntity(),
        isPinned: json['isPinned'] ?? false,
        isFavorite: json['isFavorite'] ?? false,
        pinnedAt: json['pinnedAt'] != null
            ? DateTime.tryParse(json['pinnedAt'])
            : null,
        unreadCount: json['unreadCount'] ?? 0,
        lastMessage: LastMessageModel.fromJson(json['lastMessage']).toEntity(),
      );
    } catch (e) {
      log("❌ Error in ChatModel.fromJson: $e");
      throw Exception(e);
    }
  }

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      anotherUser: UserModel.fromEntity(entity.anotherUser),
      isPinned: entity.isPinned,
      isFavorite: entity.isFavorite,
      pinnedAt: entity.pinnedAt,
      unreadCount: entity.unreadCount,
      lastMessage: LastMessageModel.fromEntity(entity.lastMessage),
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      anotherUser: UserModel.fromEntity(anotherUser).toEntity(),
      isPinned: isPinned,
      isFavorite: isFavorite,
      pinnedAt: pinnedAt,
      unreadCount: unreadCount,
      lastMessage: LastMessageModel.fromEntity(lastMessage).toEntity(),
    );
  }
}
