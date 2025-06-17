class ChatModel {
  final int id;
  final String type;
  final ChatUser anotherUser;
  final bool isPinned;
  final DateTime? pinnedAt;
  final DateTime? lastMessageCreatedAt;

  ChatModel({
    required this.id,
    required this.type,
    required this.anotherUser,
    required this.isPinned,
    required this.pinnedAt,
    required this.lastMessageCreatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      type: json['type'],
      anotherUser: ChatUser.fromJson(json['users'][0]),
      isPinned: json['is_pinned'] ?? false,
      pinnedAt: json['pinned_at'] != null
          ? DateTime.tryParse(json['pinned_at'])
          : null,
      lastMessageCreatedAt: json['lastMessageCreatedAt'] != null
          ? DateTime.tryParse(json['lastMessageCreatedAt'])
          : null,
    );
  }
}

class ChatUser {
  final int id;
  final String name;
  final String? profileImage;
  final UserChatMetadata chatMetadata;

  ChatUser({
    required this.id,
    required this.name,
    this.profileImage,
    required this.chatMetadata,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image'],
      chatMetadata: UserChatMetadata.fromJson(json['chat']),
    );
  }
}

class UserChatMetadata {
  final bool isPinned;
  final bool isFavorite;
  final DateTime? pinnedAt;

  UserChatMetadata({
    required this.isPinned,
    required this.isFavorite,
    required this.pinnedAt,
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
}
