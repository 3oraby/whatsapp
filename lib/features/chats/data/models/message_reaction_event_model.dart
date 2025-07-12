import 'package:whatsapp/features/chats/domain/entities/message_reaction_event.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';

class MessageReactionEventModel extends MessageReactionEvent {
  final String action;

  const MessageReactionEventModel({
    required super.messageId,
    required super.react,
    required super.userId,
    required this.action,
  });

  factory MessageReactionEventModel.fromJson(Map<String, dynamic> json) {
    return MessageReactionEventModel(
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

  MessageReactionEvent toEntity() {
    return MessageReactionEvent(
      messageId: messageId,
      react: react,
      userId: userId,
    );
  }

  factory MessageReactionEventModel.fromEntity(
    MessageReactionEvent entity, {
    String action = '',
  }) {
    return MessageReactionEventModel(
      messageId: entity.messageId,
      react: entity.react,
      userId: entity.userId,
      action: action,
    );
  }
}
