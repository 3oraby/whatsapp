import 'package:whatsapp/features/chats/domain/entities/chat_entity.dart';
import 'package:whatsapp/features/notifications/domain/entities/notification_message_entity.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class ChatScreenArgs {
  final int chatId;
  final UserEntity anotherUser;

  ChatScreenArgs({
    required this.chatId,
    required this.anotherUser,
  });

  static ChatScreenArgs fromChatEntity(ChatEntity chat) => ChatScreenArgs(
        chatId: chat.id,
        anotherUser: chat.anotherUser,
      );

  static ChatScreenArgs fromNotificationMessageEntity(
          NotificationMessageEntity notification) =>
      ChatScreenArgs(
        chatId: notification.chatId,
        anotherUser: UserEntity(
          id: notification.senderId,
          name: notification.username,
          profileImage: notification.profileImg,
        ),
      );
}
