import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/notifications/domain/entities/notification_message_entity.dart';
import 'package:whatsapp/features/notifications/data/models/notification_message_model.dart';

@pragma('vm:entry-point')
class AppNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    debugPrint('init app notification service');

    await messaging.requestPermission();

    final String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      debugPrint("fcm token: $fcmToken");
    }

    final UserEntity? user = getCurrentUserEntity();
    if (user != null && fcmToken != null) {
      final result = await getIt<ApiConsumer>().post(
        EndPoints.saveFcmToken,
        data: {
          "userId": user.id,
          "fcmToken": fcmToken,
        },
      );
      debugPrint('result from save fcm token: $result');
    }

    await AwesomeNotifications().initialize(
      'resource://drawable/default_user',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().setListeners(
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );

    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   // Handle foreground messages here if needed
    // });
  }

  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    debugPrint(
        "------------------------- handleBackgroundMessage -------------------------");
    debugPrint("data: ${message.data}");

    final notificationMessageEntity =
        NotificationMessageModel.fromRemoteMessage(message);

    await showChatNotification(notificationMessageEntity);
  }

  static Future<void> showChatNotification(
      NotificationMessageEntity data) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();

      final largeIcon = (data.profileImg?.isNotEmpty ?? false)
          ? await _downloadAndSaveFile(
              data.profileImg!, 'profile_${data.messageId}.jpg', tempDir)
          : null;

      final bigPicture = (data.mediaUrl?.isNotEmpty ?? false)
          ? await _downloadAndSaveFile(
              data.mediaUrl!, 'media_${data.messageId}.jpg', tempDir)
          : null;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: data.messageId,
          channelKey: 'basic_channel',
          title: data.username,
          body: _getContentText(data),
          summary: data.content,
          notificationLayout: bigPicture != null
              ? NotificationLayout.BigPicture
              : NotificationLayout.Messaging,
          largeIcon: largeIcon != null ? 'file://$largeIcon' : null,
          bigPicture: bigPicture != null ? 'file://$bigPicture' : null,
          roundedLargeIcon: true,
          wakeUpScreen: true,
          fullScreenIntent: false,
          category: NotificationCategory.Message,
          autoDismissible: true,
          displayOnForeground: true,
          displayOnBackground: true,
          payload: {
            'chatId': data.chatId.toString(),
            'senderId': data.senderId.toString(),
            'profilePath': largeIcon ?? '',
            'mediaPath': bigPicture ?? '',
          },
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Error showing notification: $e');
      debugPrint('$stackTrace');
    }
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName, Directory directory) async {
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static String _getContentText(NotificationMessageEntity data) {
    if (data.content != null && data.content!.isNotEmpty) {
      return data.content!;
    }

    if (data.mediaUrl != null && data.mediaUrl!.isNotEmpty) {
      return "📷 Photo";
    }

    return "New Message";
  }
}

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Notification created
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Notification displayed
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // ✅ Clean up temp files after dismissing the notification
    final profilePath = receivedAction.payload?['profilePath'];
    final mediaPath = receivedAction.payload?['mediaPath'];

    if (profilePath != null && profilePath.isNotEmpty) {
      final file = File(profilePath);
      if (await file.exists()) {
        await file.delete().catchError((e) {
          debugPrint("Failed to delete profile image: $e");
        });
      }
    }

    if (mediaPath != null && mediaPath.isNotEmpty) {
      final file = File(mediaPath);
      if (await file.exists()) {
        await file.delete().catchError((e) {
          debugPrint("Failed to delete media image: $e");
        });
      }
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Handle tap on notification
    // Example:
    // navigatorKey.currentState?.pushNamed(
    //   '/chat',
    //   arguments: {
    //     'chatId': receivedAction.payload?['chatId'],
    //     'senderId': receivedAction.payload?['senderId'],
    //   },
    // );
  }
}
