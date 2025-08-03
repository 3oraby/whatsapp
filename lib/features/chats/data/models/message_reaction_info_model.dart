import 'package:whatsapp/features/chats/domain/entities/message_reaction_info.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';

class MessageReactionInfoModel extends MessageReactionInfo {
  const MessageReactionInfoModel({
    required super.id,
    required super.createdAt,
    required super.user,
    required super.messageReact,
  });

  factory MessageReactionInfoModel.fromJson(Map<String, dynamic> json) {
    return MessageReactionInfoModel(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      user: UserModel.fromJson(json['user']).toEntity(),
      messageReact: MessageReactExtension.fromString(json['react']),
    );
  }

  factory MessageReactionInfoModel.fromEntity(MessageReactionInfo entity) {
    return MessageReactionInfoModel(
      id: entity.id,
      createdAt: entity.createdAt,
      user: UserModel.fromEntity(entity.user).toEntity(),
      messageReact: entity.messageReact,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'user': UserModel.fromEntity(user).toJson(),
      'react': messageReact,
    };
  }

  MessageReactionInfo toEntity() {
    return MessageReactionInfo(
      id: id,
      createdAt: createdAt,
      user: user,
      messageReact: messageReact,
    );
  }
}
