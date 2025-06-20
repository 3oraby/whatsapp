class LastMessageEntity {
  final String content;
  final String status;
  final DateTime createdAt;
  final String type;
  final int senderId;
  final bool isMine;

  const LastMessageEntity({
    required this.content,
    required this.status,
    required this.createdAt,
    required this.type,
    required this.senderId,
    required this.isMine,
  });
}
