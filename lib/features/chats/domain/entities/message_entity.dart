class MessageEntity {
  final int id;
  final String? content;
  final String? mediaUrl;
  final int? chatId;
  final int senderId;
  final int? receiverId;
  final String status;
  final int? parentId;
  final String type;
  final int? statusId;
  final bool? isDeleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MessageEntity({
    required this.id,
    required this.content,
    this.mediaUrl,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.status,
    this.parentId,
    required this.type,
    this.statusId,
    this.isDeleted,
    required this.createdAt,
    this.updatedAt,
  });
}
