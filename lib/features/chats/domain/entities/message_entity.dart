import 'package:whatsapp/features/chats/data/models/send_message_dto.dart';
import 'package:whatsapp/features/chats/domain/entities/message_reaction_info.dart';
import 'package:whatsapp/features/chats/domain/enums/message_react.dart';
import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/enums/message_type.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class MessageEntity {
  final int id;
  final String? content;
  final String? mediaUrl;
  final int? chatId;
  final int? senderId;
  final int? receiverId;
  final MessageStatus status;
  final int? parentId;
  final MessageType type;
  final int? statusId;
  final bool isDeleted;
  final bool isEdited;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFromMe;
  final int reactsCount;
  final UserEntity? sender;
  final List<MessageReactionInfo> reacts;

  MessageEntity({
    required this.id,
    required this.content,
    this.mediaUrl,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    this.status = MessageStatus.pending,
    this.parentId,
    this.type = MessageType.text,
    this.statusId,
    this.isDeleted = false,
    this.isEdited = false,
    required this.createdAt,
    this.updatedAt,
    required this.isFromMe,
    this.reactsCount = 0,
    this.sender,
    this.reacts = const [],
  });

  MessageEntity copyWith({
    int? id,
    String? content,
    String? mediaUrl,
    int? chatId,
    int? senderId,
    int? receiverId,
    MessageStatus? status,
    int? parentId,
    MessageType? type,
    int? statusId,
    bool? isDeleted,
    bool? isEdited,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFromMe,
    int? reactsCount,
    UserEntity? sender,
    List<MessageReactionInfo>? reacts,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      statusId: statusId ?? this.statusId,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFromMe: isFromMe ?? this.isFromMe,
      reactsCount: reactsCount ?? this.reactsCount,
      sender: sender ?? this.sender,
      reacts: reacts ?? this.reacts,
    );
  }

  bool hasReactFromUser(int userId) {
    return reacts.any((reaction) => reaction.user.id == userId);
  }

  MessageReact? getMessageReactType(int userId) {
    try {
      return reacts
          .firstWhere((reaction) => reaction.user.id == userId)
          .messageReact;
    } catch (e) {
      return null;
    }
  }

  factory MessageEntity.fromDto(SendMessageDto dto, int currentUserId) {
    final int tempId = -1;
    return MessageEntity(
      id: tempId,
      content: dto.content,
      senderId: currentUserId,
      receiverId: dto.receiverId,
      chatId: dto.chatId,
      parentId: dto.parentId,
      createdAt: DateTime.now(),
      type: dto.type,
      mediaUrl: dto.mediaUrl,
      isFromMe: true,
      reactsCount: 0,
    );
  }
}
