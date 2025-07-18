import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:triple_prime_mobile/core/app_router.dart';

class NotificationManager {
  static void handleNotificationTap(BuildContext context, String payload) {
    if (payload.isEmpty) return;
    
    try {
      final data = json.decode(payload);
      final type = data['type'];
      final id = data['id'];
      
      switch (type) {
        case 'food_pack':
          Navigator.pushNamed(context, AppRouter.foodPackDetail, arguments: id);
          break;
        case 'savings_plan':
          Navigator.pushNamed(context, AppRouter.mainScreen);
          break;
        case 'payment':
          Navigator.pushNamed(context, AppRouter.mainScreen);
          break;
        default:
          Navigator.pushNamed(context, AppRouter.mainScreen);
      }
    } catch (e) {
      Navigator.pushNamed(context, AppRouter.mainScreen);
    }
  }

  static Map<String, dynamic> createNotificationPayload({
    required String type,
    String? id,
    Map<String, dynamic>? additionalData,
  }) {
    final payload = {
      'type': type,
      'id': id,
      ...?additionalData,
    };
    return payload;
  }
} 