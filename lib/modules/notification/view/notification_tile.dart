/*import 'package:flutter/material.dart';
import '../model/notification_model.dart';
class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationTile({super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: notification.isRead ? Colors.grey[200] : Colors.blue[50],
      leading: Icon(Icons.notifications),
      title: Text(notification.message),
      subtitle: Text(DateTime.parse(notification.createdAt).toLocal().toString()),
      trailing: notification.isRead
          ? Icon(Icons.check_circle, color: Colors.green)
          : Icon(Icons.circle, color: Colors.red, size: 10),
      onTap: onTap,
    );
  }
}
*/