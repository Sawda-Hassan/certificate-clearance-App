import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// 🔁 Background FCM handler (required)
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('📩 [Background] Title: ${message.notification?.title}');
  print('📩 [Background] Body: ${message.notification?.body}');
  print('📩 [Background] Data: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static bool _isInitialized = false;

  Future<void> intiNotifications() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      // 🔐 Request permission
      print('🔐 Requesting notification permission...');
      NotificationSettings settings = await _firebaseMessaging.requestPermission();
      print('🔔 Permission status: ${settings.authorizationStatus}');

      // 📲 Get FCM token
      final fCMToken = await _firebaseMessaging.getToken();
      print('📲 FCM Token: $fCMToken');

      // 🔄 Token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('🔄 New FCM Token: $newToken');
        // TODO: Send to backend if needed
      });

      // ✅ Foreground handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📩 [Foreground] Title: ${message.notification?.title}');
        print('📩 [Foreground] Body: ${message.notification?.body}');
        print('📩 [Foreground] Data: ${message.data}');

        if (message.notification != null) {
          final notification = message.notification!;
          final android = notification.android;

          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                importance: Importance.high,
                priority: Priority.high,
                icon: android?.smallIcon ?? '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      });

      // ✅ Background handler
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      // ✅ Taps while app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final route = message.data['route'];
        print('🧭 [onMessageOpenedApp] route = $route');
        if (route != null) {
          Get.toNamed(route);
        } else {
          Get.toNamed('/notifications');
        }
      });

      // ✅ Cold start (app launched via notification)
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        final route = initialMessage.data['route'];
        print('🧊 [Cold Start] route = $route');
        if (route != null) {
          Future.delayed(Duration.zero, () => Get.toNamed(route));
        } else {
          Future.delayed(Duration.zero, () => Get.toNamed('/notifications'));
        }
      }
    } catch (e) {
      print('❌ Firebase Messaging init failed: $e');
    }
  }
}
