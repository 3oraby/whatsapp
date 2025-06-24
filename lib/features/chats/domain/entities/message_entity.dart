import 'package:whatsapp/features/chats/domain/enums/message_status.dart';
import 'package:whatsapp/features/chats/domain/enums/message_type.dart';
import 'package:whatsapp/features/user/domain/user_entity.dart';

class MessageEntity {
  final int id;
  final String? content;
  final String? mediaUrl;
  final int? chatId;
  final int senderId;
  final int? receiverId;
  final MessageStatus status;
  final int? parentId;
  final MessageType type;
  final int? statusId;
  final bool? isDeleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isFromMe;
  final int reactsCount;
  final UserEntity? sender;

  MessageEntity({
    required this.id,
    required this.content,
    this.mediaUrl,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    this.status = MessageStatus.sent,
    this.parentId,
    this.type = MessageType.text,
    this.statusId,
    this.isDeleted,
    required this.createdAt,
    this.updatedAt,
    required this.isFromMe,
    this.reactsCount = 0,
    this.sender,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFromMe,
    int? reactsCount,
    UserEntity? sender,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFromMe: isFromMe ?? this.isFromMe,
      reactsCount: reactsCount ?? this.reactsCount,
      sender: sender ?? this.sender,
    );
  }
}
