import 'package:flutter/material.dart';
import '../../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications;

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification); // newest first
    notifyListeners();
  }
}
