import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5000/api/students'; // Android Emulator IP

  /// Logs in the student and returns token + student data
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
      final token = body['token'];
      //print('✅ Logged in student JWT: $token');
      return {
        'success': true,
        'student': body['student'],
        'token': token
      };
    } else {
      //print('❌ Login failed: ${body['message'] ?? 'Unknown error'}');
      return {
        'success': false,
        'message': body['message'] ?? 'Login failed'
      };
    }
  }

  /// ✅ Fetch the logged-in student profile using JWT
  Future<Map<String, dynamic>?> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      //print('❌ Profile fetch failed: ${response.body}');
      return null;
    }
  }
}
