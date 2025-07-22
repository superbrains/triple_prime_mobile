import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:triple_prime_mobile/core/services/notification_manager.dart';
import 'package:triple_prime_mobile/firebase_options.dart';

class PushNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static String? _fcmToken;
  static BuildContext? _context;

  static String? get fcmToken => _fcmToken;

  static void setContext(BuildContext context) {
    _context = context;
  }

  static Future<void> initialize() async {
    await _requestPermissions();
    await _initializeLocalNotifications();
    await _getFCMToken();
    await _setupForegroundHandler();
    await _setupBackgroundHandler();
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } else {
      await Permission.notification.request();
    }
  }

  static Future<void> _initializeLocalNotifications() async {
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
  }

  static Future<void> _getFCMToken() async {
    _fcmToken = await _firebaseMessaging.getToken();
    print('FCM Token: $_fcmToken');
    _firebaseMessaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
    });
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
