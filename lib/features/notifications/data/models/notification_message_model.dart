import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:whatsapp/features/notifications/domain/entities/notification_message_entity.dart';

class NotificationMessageModel extends NotificationMessageEntity {
  const NotificationMessageModel({
    required super.senderId,
    required super.chatId,
    required super.messageId,
    required super.username,
    super.content,
    super.mediaUrl,
    super.profileImg,
    required super.title,
  });

  factory NotificationMessageModel.fromRemoteMessage(RemoteMessage message) {
    final data = message.data;

    return NotificationMessageModel(
      username: data['userName'] ?? 'Unknown User',
      title: data['title'],
      mediaUrl: data['mediaUrl'],
      senderId: int.tryParse(data['senderId'] ?? '') ?? 0,
      chatId: int.tryParse(data['chatId'] ?? '') ?? 0,
      messageId: int.tryParse(data['messageId'] ?? '') ?? 0,
      profileImg: data['profileImg'],
      content: data['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'chatId': chatId,
      'messageId': messageId,
      'username': username,
      'content': content,
      'mediaUrl': mediaUrl,
      'profileImg': profileImg,
      'title': title,
    };
  }

  static NotificationMessageModel fromJson(String jsonStr) {
    final Map<String, dynamic> data = json.decode(jsonStr);

    return NotificationMessageModel(
      senderId: data['senderId'] is String
          ? int.tryParse(data['senderId']) ?? 0
          : data['senderId'] ?? 0,
      chatId: data['chatId'] is String
          ? int.tryParse(data['chatId']) ?? 0
          : data['chatId'] ?? 0,
      messageId: data['messageId'] is String
          ? int.tryParse(data['messageId']) ?? 0
          : data['messageId'] ?? 0,
      username: data['username'] ?? 'Unknown User',
      content: data['content'],
      mediaUrl: data['mediaUrl'],
      profileImg: data['profileImg'],
      title: data['title'] ?? '',
    );
  }

  static String toJsonString(NotificationMessageEntity entity) {
    return jsonEncode({
      'senderId': entity.senderId,
      'chatId': entity.chatId,
      'messageId': entity.messageId,
      'username': entity.username,
      'content': entity.content,
      'mediaUrl': entity.mediaUrl,
      'profileImg': entity.profileImg,
      'title': entity.title,
    });
  }
}
