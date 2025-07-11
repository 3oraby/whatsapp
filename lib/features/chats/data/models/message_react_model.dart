import 'package:whatsapp/features/chats/domain/entities/message_react_entity.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';

class MessageReactionModel extends MessageReactionEntity {
  final String action;

  const MessageReactionModel({
    required super.messageId,
    required super.react,
    required super.userId,
    required this.action,
  });

  factory MessageReactionModel.fromJson(Map<String, dynamic> json) {
    return MessageReactionModel(
      messageId: json['messageId'],
      react: MessageReactExtension.fromString(json['react']),
      userId: json['userId'],
      action: json['action'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'react': react,
      'userId': userId,
      'action': action,
    };
  }

  MessageReactionEntity toEntity() {
    return MessageReactionEntity(
      messageId: messageId,
      react: react,
      userId: userId,
    );
  }

  factory MessageReactionModel.fromEntity(
    MessageReactionEntity entity, {
    String action = '',
  }) {
    return MessageReactionModel(
      messageId: entity.messageId,
      react: entity.react,
      userId: entity.userId,
      action: action,
    );
  }
}
