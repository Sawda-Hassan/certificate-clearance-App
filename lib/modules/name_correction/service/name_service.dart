import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/name_model.dart';

class NameService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/students'; // ✅ Android Emulator base URL

  /// ✅ Fetch student profile using stored ID
  static Future<StudentModel?> getStudentById(String id) async {
    try {
      final url = Uri.parse('$baseUrl/$id');
      print('📡 [GET Student] $url');

      final response = await http.get(url);

      print('📥 Status: ${response.statusCode}');
      print('📥 Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return StudentModel.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print('❌ [GET Student] Exception: $e');
      return null;
    }
  }

  /// ✅ Toggle name correction request (Yes / No)
  static Future<bool> toggleNameCorrection(String studentId, bool requested) async {
    try {
      final url = Uri.parse('$baseUrl/request-name-correction-toggle'); // ✅ Correct backend route
      final body = jsonEncode({
        'studentId': studentId,
        'requested': requested,
      });

      print('📤 [POST] $url');
      print('📦 Body: $body');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('📥 Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        try {
          final err = jsonDecode(response.body);
          print('❌ Backend Error: ${err['message']}');
        } catch (_) {
          print('❌ Response is not valid JSON');
        }
        return false;
      }
    } catch (e) {
      print('❌ Exception in toggleNameCorrection: $e');
      return false;
    }
  }
}
