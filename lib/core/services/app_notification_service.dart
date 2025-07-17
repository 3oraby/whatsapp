import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

class AppNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future init() async {
    await messaging.requestPermission();
    final String? token = await messaging.getToken();
    if (token != null) {
      debugPrint("fcm token: $token");
    }

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handleForegroundMessage();
  }

  static Future<void> handleBackgroundMessage(
      RemoteMessage remoteMessage) async {
    await Firebase.initializeApp();
    debugPrint("onBackgroundMessage: ${remoteMessage.notification?.title}");
  }

  static Future<void> handleForegroundMessage() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage remoteMessage) {
        debugPrint("onForegroundMessage: ${remoteMessage.notification?.title}");
        // push the remote message with local notification
      },
    );
  }
}
