/*import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../notification/model/notification_model.dart';
import '../../notification/service/notification_service.dart';

class NotificationController extends GetxController {
  var notifications = <AppNotification>[].obs;
  var isLoading = false.obs;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    _listenToMessages();
    _initFCMToken();
  }

  /// Fetch and print the device FCM token
  void _initFCMToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        print('📲 FCM Token: $token');
        // You may want to send this token to your backend for notification targeting
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
  }

  /// Listen to foreground messages and refresh notification list
  void _listenToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Get.snackbar(
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? '',
        snackPosition: SnackPosition.TOP, // ✅ Correct usage
      );
      fetchNotifications(); // Refresh list on new message
    });
  }

  /// Fetch notifications from backend
  void fetchNotifications() async {
    try {
      isLoading.value = true;
      final result = await NotificationService.getStudentNotifications();
      notifications.assignAll(result);
    } catch (e) {
      print('❌ Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Mark a notification as read and refresh the list
  void markAsRead(String id) async {
    try {
      await NotificationService.markNotificationAsRead(id);
      fetchNotifications();
    } catch (e) {
      print('❌ Error marking notification as read: $e');
    }
  }
}
*/