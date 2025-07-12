import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class MessageReactionInfo {
  final int id;
  final DateTime createdAt;
  final UserEntity user;

  const MessageReactionInfo({
    required this.id,
    required this.createdAt,
    required this.user,
  });
}
