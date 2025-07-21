import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/get_it_service.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

@pragma('vm:entry-point') 
class AppNotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

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

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handleForegroundMessage();
  }

  @pragma('vm:entry-point') 
  static Future<void> handleBackgroundMessage(RemoteMessage remoteMessage) async {
    await Firebase.initializeApp();
    debugPrint("onBackgroundMessage new message arrived -- title: ${remoteMessage.notification?.title} -- body: ${remoteMessage.notification?.body}");
    debugPrint("onBackgroundMessage new message arrived -- data: ${remoteMessage.data}");
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
