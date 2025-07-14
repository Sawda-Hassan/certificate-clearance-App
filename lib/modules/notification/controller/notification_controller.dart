import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/notification_model.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  Future<void> fetchNotifications(String studentId) async {
    isLoading.value = true;
    final url = Uri.parse('http://10.0.2.2:5000/api/notifications/$studentId');

    print('🔎 Fetching notifications for studentId: $studentId');
    print('🌐 GET: $url');

    try {
      final response = await http.get(url);

      print('📨 Response Code: ${response.statusCode}');
      print('📨 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          print('⚠️ No notifications found in response.');
        } else {
          print('📦 Notification count: ${data.length}');
        }

        notifications.value =
            data.map((e) {
              print('📄 Notification item: $e');
              return NotificationModel.fromJson(e);
            }).toList();
      } else {
        Get.snackbar('Error', 'Failed to load notifications');
        print('❌ Error: status code ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Server error: $e');
      print('❌ Exception during fetch: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markNotificationAsRead(String id) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/notifications/$id/read');

    print('📤 Marking notification as read: $id');

    try {
      final response = await http.patch(url);
      print('✅ Mark as read response: ${response.statusCode}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark as read');
      print('❌ Error marking as read: $e');
    }
  }
}
