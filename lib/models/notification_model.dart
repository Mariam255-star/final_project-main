import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? orderData;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.orderData,
    required this.createdAt,
    this.isRead = false,
  });

  factory AppNotification.fromFirebase(
    Map<String, dynamic> data,
    String docId,
  ) {
    return AppNotification(
      id: docId,
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'No Title',
      body: data['body'] ?? '',
      type: data['type'] ?? 'order_confirmed',
      orderData: data['orderData'],
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'orderData': orderData,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }

  factory AppNotification.fromFirebaseMessage(Map<String, dynamic> data) {
    return AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'No Title',
      body: data['body'] ?? '',
      type: data['type'] ?? 'order_confirmed',
      orderData: data['orderData'] != null
          ? Map<String, dynamic>.from(data['orderData'] as Map)
          : null,
      createdAt: DateTime.now(),
      isRead: false,
    );
  }
}
