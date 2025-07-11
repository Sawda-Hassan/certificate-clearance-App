import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  bool read;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    this.read = false,
  });
}

class NotificationProvider extends ChangeNotifier {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      title: "Finance Cleared",
      message: "Your finance clearance has been approved.",
      time: "2 hours ago",
      icon: Icons.check_circle,
      color: Colors.green,
    ),
    NotificationItem(
      title: "New Appointment Scheduled",
      message:
          "Your certificate collection appointment is on June 3, 2025 at 10:30 AM.",
      time: "Yesterday",
      icon: Icons.event,
      color: Colors.blue,
    ),
    NotificationItem(
      title: "Examination Rejected",
      message: "Please upload your thesis document to proceed.",
      time: "2 days ago",
      icon: Icons.warning,
      color: Colors.orange,
    ),
  ];

  List<NotificationItem> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.read).length;

  void markAsRead(int index) {
    _notifications[index].read = true;
    notifyListeners();
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.read = true;
    }
    notifyListeners();
  }

  void delete(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }

  void undoDelete(int index, NotificationItem item) {
    _notifications.insert(index, item);
    notifyListeners();
  }
}
