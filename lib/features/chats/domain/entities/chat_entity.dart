
class ChatEntity {
  final int id;
  final String type;
  final ChatUserEntity anotherUser;
  final bool isPinned;
  final DateTime? pinnedAt;
  final DateTime? lastMessageCreatedAt;

  const ChatEntity({
    required this.id,
    required this.type,
    required this.anotherUser,
    required this.isPinned,
    required this.pinnedAt,
    required this.lastMessageCreatedAt,
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
