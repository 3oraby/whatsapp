import 'package:whatsapp/features/chats/domain/entities/message_entity.dart';

class ChatEntity {
  final int id;
  final String type;
  final ChatUserEntity anotherUser;
  final bool isPinned;
  final DateTime? pinnedAt;
  final DateTime? lastMessageCreatedAt;
  final List<MessageEntity> messages;

  const ChatEntity({
    required this.id,
    required this.type,
    required this.anotherUser,
    required this.isPinned,
    required this.pinnedAt,
    required this.lastMessageCreatedAt,
    required this.messages,
  });
}

class ChatUserEntity {
  final int id;
  final String name;
  final String? profileImage;
  final UserChatMetadataEntity chatMetadata;

  const ChatUserEntity({
    required this.id,
    required this.name,
    this.profileImage,
    required this.chatMetadata,
  });
}

class UserChatMetadataEntity {
  final bool isPinned;
  final bool isFavorite;
  final DateTime? pinnedAt;

  const UserChatMetadataEntity({
    required this.isPinned,
    required this.isFavorite,
    required this.pinnedAt,
  });

}
