import 'package:whatsapp/features/chats/domain/entities/last_message_entity.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class ChatEntity {
  final int id;
  final UserEntity anotherUser;
  final bool isPinned;
  final bool isFavorite;
  final LastMessageEntity lastMessage;
  final int unreadCount;
  final DateTime? pinnedAt;

  const ChatEntity({
    required this.id,
    required this.anotherUser,
    required this.isPinned,
    required this.isFavorite,
    required this.lastMessage,
    required this.unreadCount,
    this.pinnedAt,
  });
}
