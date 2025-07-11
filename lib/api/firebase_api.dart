import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// 🔁 Background FCM handler (required for background messages)
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

      // 🔄 Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('🔄 New FCM Token: $newToken');
        // You can send newToken to your backend if needed
      });

      // ✅ Foreground message handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📩 [Foreground] Title: ${message.notification?.title}');
        print('📩 [Foreground] Body: ${message.notification?.body}');
        print('📩 [Foreground] Data: ${message.data}');

        if (message.notification != null) {
          final notification = message.notification!;
          final android = message.notification?.android;

          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel', // Channel must match the one in setupNotificationChannel()
                'High Importance Notifications',
                importance: Importance.high,
                priority: Priority.high,
                icon: android?.smallIcon ?? '@mipmap/ic_launcher',
              ),
            ),
          );
        }
      });

      // ✅ Background message handler
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    } catch (e) {
      print('❌ Firebase Messaging init failed: $e');
    }
  }
}