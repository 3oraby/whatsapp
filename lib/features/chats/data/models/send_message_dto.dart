import 'package:whatsapp/features/chats/domain/enums/message_type.dart';

class SendMessageDto {
  final int receiverId;
  final int chatId;
  final int? parentId;
  final String content;
  final MessageType type;
  final String? mediaUrl;

  SendMessageDto({
    required this.receiverId,
    required this.chatId,
    required this.content,
    this.parentId,
    this.mediaUrl,
    this.type = MessageType.text,
  });

  Map<String, dynamic> toSocketPayload() => {
        "receiverId": receiverId,
        "message": {
          "content": content,
          "chatId": chatId,
          "parent_id": parentId,
          "type": type.value,
          "media_url": mediaUrl,
        }
      };

  factory SendMessageDto.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as Map<String, dynamic>;
    return SendMessageDto(
      receiverId: json['receiverId'] as int,
      chatId: message['chatId'] as int,
      content: message['content'] as String,
      parentId: message['parent_id'] as int?,
      type: MessageTypeExtension.fromString(message['type'] as String),
      mediaUrl: message['media_url'] as String?,
    );
  }
}
