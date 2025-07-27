import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/features/notifications/data/models/notification_message_model.dart';
import 'package:whatsapp/features/notifications/domain/entities/notification_message_entity.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

@pragma('vm:entry-point')
class AppNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future init() async {
    debugPrint('init app notification service');
    await messaging.requestPermission();
    final String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      debugPrint("fcm token: $fcmToken");
    }

    final UserEntity? user = getCurrentUserEntity();
    if (user != null) {
      final result = await getIt<ApiConsumer>().post(
        EndPoints.saveFcmToken,
        data: {
          "userId": user.id,
          "fcmToken": fcmToken,
        },
      );
      debugPrint('result from save fcm token: $result');
    }

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // handleForegroundMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("onMessageOpenedApp: ${message.notification?.title}");
    });
  }

  @pragma('vm:entry-point')
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    // await Firebase.initializeApp();
    debugPrint("notification data: ${message.data}");
    debugPrint(
        "onBackgroundMessage -- title: ${message.notification?.title} -- body: ${message.notification?.body}");
    _showNotification(message);
  }

  static void handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          "onForegroundMessage -- title: ${message.notification?.title} -- body: ${message.notification?.body}");
      _showNotification(message);
    });
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    final NotificationMessageEntity notificationMessageEntity =
        NotificationMessageModel.fromRemoteMessage(message);

    final String? profileImg = notificationMessageEntity.profileImg;

    AndroidNotificationDetails androidDetails;

    AndroidBitmap<Object>? largeIcon;

    if (profileImg != null && profileImg.isNotEmpty) {
      try {
        final filePath =
            await _downloadAndSaveFile(profileImg, 'profile_image.jpg');
        largeIcon = FilePathAndroidBitmap(filePath);
      } catch (e) {
        debugPrint('Error downloading image: $e');
        largeIcon =
            const DrawableResourceAndroidBitmap('default_user'); // fallback
      }
    } else {
      largeIcon = const DrawableResourceAndroidBitmap('default_user');
    }

    androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      largeIcon: largeIcon,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        notificationMessageEntity.content ?? 'New Message',
        contentTitle: notificationMessageEntity.username,
        summaryText: notificationMessageEntity.content,
      ),
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notificationMessageEntity.username,
      notificationMessageEntity.content ?? 'New Message',
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
