import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/features/chats/data/models/message_model.dart';
import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';

import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.type,
    required super.anotherUser,
    required super.isPinned,
    required super.pinnedAt,
    required super.lastMessageCreatedAt,
    required super.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final int currentUserId = getCurrentUserEntity().id;

    final usersList =
        (json['users'] as List).map((u) => ChatUser.fromJson(u)).toList();

    final anotherUser = usersList.firstWhere(
      (user) => user.id != currentUserId,
      orElse: () => throw Exception('Another user not found'),
    );

    final List<MessageEntity> messages = (json['messages'] as List)
        .map((m) => MessageModel.fromJson(m).toEntity())
        .toList();

    return ChatModel(
      id: json['id'],
      type: json['type'],
      anotherUser: anotherUser,
      isPinned: json['is_pinned'] ?? false,
      pinnedAt: json['pinned_at'] != null
          ? DateTime.tryParse(json['pinned_at'])
          : null,
      lastMessageCreatedAt: json['lastMessageCreatedAt'] != null
          ? DateTime.tryParse(json['lastMessageCreatedAt'])
          : null,
      messages: messages,
    );
  }

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      type: entity.type,
      anotherUser: ChatUser.fromEntity(entity.anotherUser),
      isPinned: entity.isPinned,
      pinnedAt: entity.pinnedAt,
      lastMessageCreatedAt: entity.lastMessageCreatedAt,
      messages:
          entity.messages.map((m) => MessageModel.fromEntity(m)).toList(),
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      type: type,
      anotherUser: ChatUser.fromEntity(anotherUser).toEntity(),
      isPinned: isPinned,
      pinnedAt: pinnedAt,
      lastMessageCreatedAt: lastMessageCreatedAt,
      messages: messages,
    );
  }
}

class ChatUser extends ChatUserEntity {
  ChatUser({
    required super.id,
    required super.name,
    super.profileImage,
    required UserChatMetadata super.chatMetadata,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image'],
      chatMetadata: UserChatMetadata.fromJson(json['chat']),
    );
  }

  factory ChatUser.fromEntity(ChatUserEntity entity) {
    return ChatUser(
      id: entity.id,
      name: entity.name,
      profileImage: entity.profileImage,
      chatMetadata: UserChatMetadata.fromEntity(entity.chatMetadata),
    );
  }

  ChatUserEntity toEntity() {
    return ChatUserEntity(
      id: id,
      name: name,
      profileImage: profileImage,
      chatMetadata: UserChatMetadata.fromEntity(chatMetadata).toEntity(),
    );
  }
}

class UserChatMetadata extends UserChatMetadataEntity {
  UserChatMetadata({
    required super.isPinned,
    required super.isFavorite,
    required super.pinnedAt,
  });

  factory UserChatMetadata.fromJson(Map<String, dynamic> json) {
    return UserChatMetadata(
      isPinned: json['is_pinned'] ?? false,
      isFavorite: json['is_favorite'] ?? false,
      pinnedAt: json['pinned_at'] != null
          ? DateTime.tryParse(json['pinned_at'])
          : null,
    );
  }

  factory UserChatMetadata.fromEntity(UserChatMetadataEntity entity) {
    return UserChatMetadata(
      isPinned: entity.isPinned,
      isFavorite: entity.isFavorite,
      pinnedAt: entity.pinnedAt,
    );
  }

  UserChatMetadataEntity toEntity() {
    return UserChatMetadataEntity(
      isPinned: isPinned,
      isFavorite: isFavorite,
      pinnedAt: pinnedAt,
    );
  }
}
