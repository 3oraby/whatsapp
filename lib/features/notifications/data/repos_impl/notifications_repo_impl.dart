import 'package:flutter/material.dart';
import 'package:whatsapp/core/api/api_consumer.dart';
import 'package:whatsapp/core/api/end_points.dart';
import 'package:whatsapp/core/constants/storage_keys.dart';
import 'package:whatsapp/core/helpers/get_current_user_entity.dart';
import 'package:whatsapp/core/services/app_notification_service.dart';
import 'package:whatsapp/core/storage/app_storage_helper.dart';
import 'package:whatsapp/features/notifications/domain/repos/notifications_repo.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class NotificationsRepoImpl extends NotificationsRepo {
  final AppNotificationService appNotificationService;
  final ApiConsumer apiConsumer;
  NotificationsRepoImpl({
    required this.appNotificationService,
    required this.apiConsumer,
  });

  @override
  Future<void> saveFcmToken() async {
    final token = await appNotificationService.getFcmToken();

    debugPrint("save fcm token");
    final String? locallyFcmToken =
        await AppStorageHelper.getSecureData(StorageKeys.fcmToken.toString());

    // send the fcm token only if changed
    if (locallyFcmToken != token && token != null) {
      debugPrint("send the fcm token to backend");
      final UserEntity? user = getCurrentUserEntity();
      if (user != null) {
        final result = await apiConsumer.post(
          EndPoints.saveFcmToken,
          data: {
            "userId": user.id,
            "fcmToken": token,
          },
        );
        debugPrint('result from save fcm token: $result');

        await AppStorageHelper.setSecureData(
          StorageKeys.fcmToken.toString(),
          token,
        );
      }
    } else {
      debugPrint("fcm token not changed");
    }
  }
}
