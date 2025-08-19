import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:triple_prime_mobile/core/services/notification_manager.dart';
import 'package:triple_prime_mobile/core/services/user_service.dart';
import 'package:triple_prime_mobile/firebase_options.dart';

class PushNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static String? _fcmToken;
  static BuildContext? _context;
  static final _logger = Logger();

  static String? get fcmToken => _fcmToken;

  static void setContext(BuildContext context) {
    _context = context;
  }

  static Future<void> initialize() async {
    try {
      _logger.i('🚀 Initializing Push Notification Service...');

      await _requestPermissions();
      await _initializeLocalNotifications();
      await _getFCMToken();
      await _setupForegroundHandler();
      await _setupBackgroundHandler();

      _logger.i('✅ Push Notification Service initialized successfully');
    } catch (e) {
      _logger.e('💥 Error initializing Push Notification Service: $e');
    }
  }

  static Future<void> _requestPermissions() async {
    try {
      if (Platform.isIOS) {
        final settings = await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        _logger.i(
            '📱 iOS notification permission status: ${settings.authorizationStatus}');
      } else {
        final status = await Permission.notification.request();
        _logger.i('📱 Android notification permission status: $status');
      }
    } catch (e) {
      _logger.e('💥 Error requesting notification permissions: $e');
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _logger.i('✅ Local notifications initialized successfully');
    } catch (e) {
      _logger.e('💥 Error initializing local notifications: $e');
    }
  }

  static Future<void> _getFCMToken() async {
    try {
      if (Platform.isIOS) {
        try {
          final apnsToken = await _firebaseMessaging.getAPNSToken();
          _logger.i('📱 APNS Token: $apnsToken');

          if (apnsToken == null) {
            _logger.w(
                '⚠️ APNS token is null, waiting before getting FCM token...');
            await Future.delayed(const Duration(seconds: 2));
          }
        } catch (apnsError) {
          _logger.w('⚠️ Error getting APNS token: $apnsError');
        }
      }

      _fcmToken = await _firebaseMessaging.getToken();
      _logger.i('📱 FCM Token: $_fcmToken');

      _firebaseMessaging.onTokenRefresh.listen((token) {
        _fcmToken = token;
        _updateDeviceTokenOnServer(token);
      });
    } catch (e) {
      _logger.e('💥 Error getting FCM token: $e');

      if (e.toString().contains('apns-token-not-set') && Platform.isIOS) {
        _logger.i('🔄 Retrying FCM token retrieval after APNS token error...');
        await Future.delayed(const Duration(seconds: 3));
        try {
          _fcmToken = await _firebaseMessaging.getToken();
          _logger.i('📱 FCM Token (retry): $_fcmToken');
        } catch (retryError) {
          _logger.e('💥 Error getting FCM token on retry: $retryError');
        }
      }
    }
  }

  static Future<void> updateDeviceTokenOnServer() async {
    if (_fcmToken == null || _fcmToken!.isEmpty) {
      _logger.w('⚠️ FCM Token is null or empty, cannot update device token');
      return;
    }

    try {
      final userService = UserService();
      final response = await userService.updateDeviceToken(
        deviceToken: _fcmToken!,
      );

      if (response.success) {
        _logger.i('✅ Device token updated successfully on server');
      } else {
        _logger.e(
            '❌ Failed to update device token on server: ${response.message}');
      }
    } catch (e) {
      _logger.e('💥 Error updating device token on server: $e');
    }
  }

  static Future<void> _updateDeviceTokenOnServer(String token) async {
    try {
      final userService = UserService();
      final response = await userService.updateDeviceToken(
        deviceToken: token,
      );

      if (response.success) {
        _logger
            .i('✅ Device token updated successfully on server after refresh');
      } else {
        _logger.e(
            '❌ Failed to update device token on server after refresh: ${response.message}');
      }
    } catch (e) {
      _logger.e('💥 Error updating device token on server after refresh: $e');
    }
  }

  static Future<void> _setupForegroundHandler() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  static Future<void> _setupBackgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null && _context != null) {
      NotificationManager.handleNotificationTap(_context!, response.payload!);
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'triple_prime_channel',
      'Tripple Prime Notifications',
      channelDescription: 'Notifications for Tripple Prime app',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      details,
      payload: json.encode(message.data),
    );
  }

  static Future<void> showLocalNotification(RemoteMessage message) async {
    await _showLocalNotification(message);
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
