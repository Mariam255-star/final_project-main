import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:final_project/models/notification_model.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔔 Notification permission: ${settings.authorizationStatus}');

    String? token = await _firebaseMessaging.getToken();
    print("🔥 FCM Token: $token");

    if (_auth.currentUser != null) {
      await _saveFCMToken(token);
    }

    await _initLocalNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(" Notification Received (Foreground)");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");

      _handleNotification(message);
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification Clicked");
      _handleNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// 🔹 Initialize Local Notifications
  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);
  }

  /// 🔹 Show Local Notification (Mobile notification badge)
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'order_channel',
          'Order Notifications',
          priority: Priority.high,
          importance: Importance.max,
          enableVibration: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      notificationDetails,
    );
  }

  /// 🔹 Handle notification (save to Firestore)
  static Future<void> _handleNotification(RemoteMessage message) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final notification = AppNotification(
        id:
            message.messageId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        title: message.notification?.title ?? 'Notification',
        body: message.notification?.body ?? '',
        type: message.data['type'] ?? 'order_confirmed',
        orderData: message.data.isNotEmpty ? message.data : null,
        createdAt: DateTime.now(),
        isRead: false,
      );

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .add(notification.toFirestore());

      print('✅ Notification saved to Firestore');
    } catch (e) {
      print('❌ Error saving notification: $e');
    }
  }

  /// 🔹 Save FCM Token to Firestore
  static Future<void> _saveFCMToken(String? token) async {
    try {
      final user = _auth.currentUser;
      if (user == null || token == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({'fcmToken': token, 'lastTokenUpdate': Timestamp.now()})
          .catchError((_) {
            // Create if document doesn't exist
            return _firestore.collection('users').doc(user.uid).set({
              'fcmToken': token,
              'lastTokenUpdate': Timestamp.now(),
            }, SetOptions(merge: true));
          });

      print('✅ FCM Token saved');
    } catch (e) {
      print('❌ Error saving FCM token: $e');
    }
  }

  /// 🔹 Background handler
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    print("🌙 Notification in Background");
    print("Title: ${message.notification?.title}");
  }

  /// 🔹 Send Notification from App (for order confirmation)
  static Future<void> sendOrderNotification({
    required String title,
    required String body,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final notification = AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        title: title,
        body: body,
        type: 'order_confirmed',
        orderData: orderData,
        createdAt: DateTime.now(),
        isRead: false,
      );

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .add(notification.toFirestore());

      // Show local notification
      await _showLocalNotificationCustom(title, body);

      print('✅ Order notification sent');
    } catch (e) {
      print('❌ Error sending notification: $e');
    }
  }

  /// 🔹 Show custom local notification
  static Future<void> _showLocalNotificationCustom(
    String title,
    String body,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'order_channel',
          'Order Notifications',
          priority: Priority.high,
          importance: Importance.max,
          enableVibration: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
    );
  }

  /// 🔹 Get all notifications for user
  static Stream<List<AppNotification>> getNotifications() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => AppNotification.fromFirebase(doc.data(), doc.id))
              .toList();
        });
  }

  /// 🔹 Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});

      print('✅ Notification marked as read');
    } catch (e) {
      print('❌ Error marking notification: $e');
    }
  }

  /// 🔹 Delete notification
  static Future<void> deleteNotification(String notificationId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .delete();

      print('✅ Notification deleted');
    } catch (e) {
      print('❌ Error deleting notification: $e');
    }
  }
}
