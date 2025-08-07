import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp/core/utils/app_routes.dart';
import 'package:whatsapp/features/chats/domain/entities/chat_screen_args.dart';
import 'package:whatsapp/features/notifications/domain/entities/notification_message_entity.dart';
import 'package:whatsapp/features/notifications/data/models/notification_message_model.dart';
import 'package:whatsapp/main.dart';

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

  Future<String?> getFcmToken() async {
    final String? fcmToken = await messaging.getToken();
    debugPrint("fcm token: $fcmToken");

    return fcmToken;
  }

  Future<void> init() async {
    debugPrint('init app notification service');

    await messaging.requestPermission();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@drawable/default_user');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("onDidReceiveNotificationResponse");
        final payload = details.payload;
        if (payload != null) {
          final NotificationMessageEntity data =
              NotificationMessageModel.fromJson(payload);

          debugPrint(payload);
          navigatorKey.currentState?.pushNamed(
            Routes.chatScreenRoute,
            arguments: ChatScreenArgs.fromNotificationMessageEntity(data),
          );
        }
      },
      // onDidReceiveBackgroundNotificationResponse: (details) {
      //   debugPrint("onDidReceiveBackgroundNotificationResponse");
      //   final payload = details.payload;
      //   if (payload != null) {
      //     final data = NotificationMessageModel.fromJson(payload);
      //     // onNotificationTap(data);
      //   }
      // },
    );

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
        payload: NotificationMessageModel.toJsonString(data),
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
