class NotificationMessageEntity {
  final int senderId;
  final int chatId;
  final int messageId;
  final String title;
  final String username;
  final String? content;
  final String? mediaUrl;
  final String? profileImg;

  const NotificationMessageEntity({
    required this.senderId,
    required this.chatId,
    required this.messageId,
    required this.username,
    required this.title,
    this.content,
    this.mediaUrl,
    this.profileImg,
  });
}
