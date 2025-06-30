import 'package:whatsapp/features/chats/domain/entities/last_message_entity.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class ChatEntity {
  final int id;
  final UserEntity anotherUser;
  final bool isPinned;
  final bool isFavorite;
  final int unreadCount;
  final LastMessageEntity? lastMessage;
  final DateTime? pinnedAt;

  const ChatEntity({
    required this.id,
    required this.anotherUser,
    required this.isPinned,
    required this.isFavorite,
    required this.lastMessage,
    this.unreadCount = 0,
    this.pinnedAt,
  });

  factory ChatEntity.empty({
    required int chatId,
    required UserEntity anotherUser,
  }) {
    return ChatEntity(
      id: chatId,
      anotherUser: anotherUser,
      isPinned: false,
      isFavorite: false,
      lastMessage: null,
      unreadCount: 0,
      pinnedAt: null,
    );
  }
}
