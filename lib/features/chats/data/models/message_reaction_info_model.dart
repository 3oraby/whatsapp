import 'package:whatsapp/features/chats/domain/entities/message_reaction_info.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';

class MessageReactionInfoModel extends MessageReactionInfo {
  const MessageReactionInfoModel({
    required super.id,
    required super.createdAt,
    required super.user,
  });

  factory MessageReactionInfoModel.fromJson(Map<String, dynamic> json) {
    return MessageReactionInfoModel(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      user: UserModel.fromJson(json['user']).toEntity(),
    );
  }

  factory MessageReactionInfoModel.fromEntity(MessageReactionInfo entity) {
    return MessageReactionInfoModel(
      id: entity.id,
      createdAt: entity.createdAt,
      user: UserModel.fromEntity(entity.user).toEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'user': UserModel.fromEntity(user).toJson(),
    };
  }

  MessageReactionInfo toEntity() {
    return MessageReactionInfo(
      id: id,
      createdAt: createdAt,
      user: user,
    );
  }
}
