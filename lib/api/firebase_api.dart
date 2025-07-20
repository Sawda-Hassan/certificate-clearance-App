import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('📩 [Background] Notification received');
  print('📩 Title: ${message.notification?.title}');
  print('📩 Body: ${message.notification?.body}');
  print('📩 Data: ${message.data}');
}

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static bool _isInitialized = false;

  Future<void> intiNotifications() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      print('🔐 Requesting notification permission...');
      NotificationSettings settings = await _firebaseMessaging.requestPermission();
      print('🔔 Permission status: ${settings.authorizationStatus}');

      final fCMToken = await _firebaseMessaging.getToken();
      print('📲 FCM Token: $fCMToken');

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('🔄 New FCM Token: $newToken');
      });

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📩 [Foreground] Notification received');
        _showLocalNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final route = message.data['route'];
        print('🧭 [onMessageOpenedApp] route = $route');
        if (route != null && route.isNotEmpty) {
          Get.toNamed(route);
        } else {
          Get.toNamed('/notifications');
        }
      });

      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        final route = initialMessage.data['route'];
        print('🧊 [Cold Start] route = $route');
        if (route != null && route.isNotEmpty) {
          Future.delayed(Duration.zero, () => Get.toNamed(route));
        } else {
          Future.delayed(Duration.zero, () => Get.toNamed('/notifications'));
        }
      }

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);

      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          print('🎯 [Tapped Notification]');
          print('🎯 payload: ${response.payload}');
          print('🎯 responseType: ${response.notificationResponseType}');
          final payload = response.payload;
          if (payload != null && payload.isNotEmpty) {
            Get.toNamed(payload);
          } else {
            Get.toNamed('/notifications');
          }
        },
      );
    } catch (e) {
      print('❌ Firebase Messaging initialization failed: $e');
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = notification?.android;
    final route = message.data['route'];
    print('🧭 Showing local notification with route: $route');

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'Used for important alerts',
            importance: Importance.high,
            priority: Priority.high,
            icon: android.smallIcon ?? '@mipmap/ic_launcher',
          ),
        ),
        payload: route,
      );
    }
  }
}
