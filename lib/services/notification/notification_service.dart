import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  /// 🔥 Initialize Firebase Messaging
  static Future<void> init() async {
    // 🟢 طلب إذن الإشعارات (iOS + Android 13+)
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔔 Notification permission: ${settings.authorizationStatus}');

    // 🟢 جلب FCM Token
    String? token = await _firebaseMessaging.getToken();
    print("🔥 FCM Token: $token");

    // 🟢 استقبال الإشعار والتطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 New Notification (Foreground)");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Data: ${message.data}");
    });

    // 🟢 لما المستخدم يضغط على الإشعار والتطبيق في الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 Notification Clicked (Background)");
      print("Data: ${message.data}");
    });
  }

  /// 🟢 التعامل مع الإشعارات في الخلفية
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("🌙 Notification in Background");
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
  }
}
