/*import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/notification_model.dart';

class NotificationService {
  static const baseUrl = 'http://10.0.2.2:5000/api/notifications';

  static Future<List<AppNotification>> fetchNotifications(String studentId) async {
    final res = await http.get(Uri.parse('$baseUrl/$studentId'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => AppNotification.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  static Future<void> markAsRead(String id) async {
    final res = await http.patch(Uri.parse('$baseUrl/$id'));
    if (res.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }
}
*/