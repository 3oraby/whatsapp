import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/notifications/domain/entities/notification_message_entity.dart';
import 'package:whatsapp/features/notifications/data/models/notification_message_model.dart';

@pragma('vm:entry-point')
class AppNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'whatsapp_channel',
    'WhatsApp-style Notifications',
    description: 'Channel for WhatsApp-style messages',
    importance: Importance.high,
  );

  Future<void> init() async {
    debugPrint('init app notification service');

    await messaging.requestPermission();

    final String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      debugPrint("fcm token: $fcmToken");
    }

    final String? locallyFcmToken =
        await AppStorageHelper.getSecureData(StorageKeys.fcmToken.toString());

    // send the fsm token only if changed
    if (locallyFcmToken != fcmToken) {
      debugPrint("send the fcm token to backend");
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

        await AppStorageHelper.setSecureData(
          StorageKeys.fcmToken.toString(),
          fcmToken,
        );
      }
    } else {
      debugPrint("fcm token not changed");
    }

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@drawable/default_user');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // enable if we have fore ground notifications
    // handleForegroundMessage();
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

  // static void handleForegroundMessage() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     debugPrint(
  //         "onForegroundMessage -- title: ${message.notification?.title} -- body: ${message.notification?.body}");
  //     if (message.notification != null) {
  //       debugPrint("Skipping background duplicate notification");
  //       return;
  //     }

  //     final notificationMessageEntity =
  //         NotificationMessageModel.fromRemoteMessage(message);

  //     await showChatNotification(notificationMessageEntity);
  //   });
  // }

  static Future<void> showChatNotification(
      NotificationMessageEntity data) async {
    try {
      final largeIcon = (data.profileImg?.isNotEmpty ?? false)
          ? await _downloadAndSaveFile(
              data.profileImg!, 'profile_${data.messageId}.jpg')
          : null;

      final bigPicture = (data.mediaUrl?.isNotEmpty ?? false)
          ? await _downloadAndSaveFile(
              data.mediaUrl!, 'media_${data.messageId}.jpg')
          : null;

      final Person person = Person(
        key: data.messageId.toString(),
        name: data.username,
        important: true,
        icon: largeIcon != null ? BitmapFilePathAndroidIcon(largeIcon) : null,
      );

      final StyleInformation style = bigPicture == null
          ? MessagingStyleInformation(
              person,
              conversationTitle: 'New Message',
              htmlFormatTitle: true,
              htmlFormatContent: true,
              messages: [
                Message(
                  data.content ?? "",
                  DateTime.now(),
                  person,
                )
              ],
            )
          : BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicture),
              largeIcon:
                  largeIcon != null ? FilePathAndroidBitmap(largeIcon) : null,
              contentTitle: data.username,
            );

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: style,
      );

      final platformDetails = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        data.messageId,
        data.username,
        _getContentText(data),
        platformDetails,
        payload: data.toString(),
      );
    } catch (e, stackTrace) {
      debugPrint('Error showing notification: $e');
      debugPrint('$stackTrace');
    }
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final directory = await getTemporaryDirectory();
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
