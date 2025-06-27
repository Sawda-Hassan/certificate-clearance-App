// 📁 lib/notification/service/notification_service.dart
/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../model/notification_model.dart';

class NotificationService {
  static final box = GetStorage();
  static final String baseUrl = "http://10.0.2.2:5000/api/notifications";

  /// 🔹 Get all notifications for the current student
  static Future<List<AppNotification>> getStudentNotifications() async {
    final studentId = box.read('studentId');
    if (studentId == null) throw Exception('Student ID not found in storage');

    final url = Uri.parse('$baseUrl/$studentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => AppNotification.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notifications: ${response.body}');
    }
  }

  /// 🔹 Mark a notification as read
  static Future<void> markNotificationAsRead(String id) async {
    final url = Uri.parse('$baseUrl/mark-read/$id');
    final response = await http.post(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read: ${response.body}');
    }
  }
}

*/