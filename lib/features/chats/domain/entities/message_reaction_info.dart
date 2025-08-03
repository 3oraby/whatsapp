import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class MessageReactionInfo {
  final int id;
  final DateTime createdAt;
  final MessageReact messageReact;
  final UserEntity user;

  const MessageReactionInfo({
    required this.id,
    required this.createdAt,
    required this.messageReact,
    required this.user,
  });
}
