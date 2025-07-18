import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:triple_prime_mobile/core/services/push_notification_service.dart';
import 'package:triple_prime_mobile/core/services/notification_manager.dart';

class NotificationUtils {
  static Future<void> sendTestNotification() async {
    await PushNotificationService.showLocalNotification(
      RemoteMessage(
        notification: RemoteNotification(
          title: 'Test Notification',
          body: 'This is a test notification from Triple Prime',
        ),
        data: NotificationManager.createNotificationPayload(
          type: 'test',
          additionalData: {'timestamp': DateTime.now().toIso8601String()},
        ),
      ),
    );
  }

  static Future<void> subscribeToUserTopic(String userId) async {
    await PushNotificationService.subscribeToTopic('user_$userId');
  }

  static Future<void> subscribeToGeneralTopic() async {
    await PushNotificationService.subscribeToTopic('general');
  }

  static Future<void> subscribeToFoodPackTopic() async {
    await PushNotificationService.subscribeToTopic('food_packs');
  }

  static Future<void> subscribeToSavingsTopic() async {
    await PushNotificationService.subscribeToTopic('savings');
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await PushNotificationService.unsubscribeFromTopic(topic);
  }

  static String? getFCMToken() {
    return PushNotificationService.fcmToken;
  }
}
