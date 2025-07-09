/*import 'dart:developer';
import 'package:get/get.dart';
import '../model/notification_model.dart';
import '../service/notification_service.dart';

class NotificationController extends GetxController {
  var notifications = <AppNotification>[].obs;
  var isLoading = false.obs;

  Future<void> loadNotifications(String studentId) async {
    isLoading.value = true;
    try {
      final data = await NotificationService.fetchNotifications(studentId);
      notifications.value = data;
    } catch (e) {
      log('❌ Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    await NotificationService.markAsRead(id);
    int index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }
}
*/