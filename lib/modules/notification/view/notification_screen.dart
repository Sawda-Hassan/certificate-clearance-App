/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../controller/notification_controller.dart';
import './notification_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controller = Get.put(NotificationController());
  final String studentId = '123456'; // Replace with real login id

  @override
  void initState() {
    super.initState();
    _setupFCM();
    controller.loadNotifications(studentId);
  }

  void _setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();
    String? token = await messaging.getToken();
    print('🔑 FCM Token: $token');

    FirebaseMessaging.onMessage.listen((message) {
      controller.loadNotifications(studentId);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification?.title ?? 'New Message'),
          content: Text(message.notification?.body ?? ''),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))
          ],
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      controller.loadNotifications(studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Obx(() {
        if (controller.isLoading.value) return Center(child: CircularProgressIndicator());
        if (controller.notifications.isEmpty) return Center(child: Text('No notifications.'));
        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final note = controller.notifications[index];
            return NotificationTile(
              notification: note,
              onTap: () => controller.markAsRead(note.id),
            );
          },
        );
      }),
    );
  }
}
*/