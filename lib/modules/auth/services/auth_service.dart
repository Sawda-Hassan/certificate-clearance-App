import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000/api/students'; // Android Emulator

  /// Login and return result map
  Future<Map<String, dynamic>> login(String studentId, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'studentId': studentId,
        'password': password,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'student': body['student'],
        'token': body['token'],
      };
    } else {
      return {
        'success': false,
        'message': body['message'] ?? 'Login failed',
      };
    }
  }

  /// Save FCM token to backend using JWT
  Future<void> sendFcmTokenToBackend(String token) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken == null) {
        print("⚠️ FCM token is null");
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/save-fcm-token'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );

      if (response.statusCode == 200) {
        print('✅ FCM token saved successfully');
      } else {
        print('❌ Failed to save FCM token: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending FCM token: $e');
    }
  }

  /// Fetch authenticated student profile
  Future<Map<String, dynamic>?> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('❌ Profile fetch failed: ${response.body}');
      return null;
    }
  }
}
