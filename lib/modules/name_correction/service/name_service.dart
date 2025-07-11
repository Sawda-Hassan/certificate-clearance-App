import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/name_model.dart';

class NameService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/students';

  static Future<StudentModel?> getStudentById(String id) async {
    try {
      final url = Uri.parse('$baseUrl/$id');
      //print('📡 Fetching student profile from: $url');

      final response = await http.get(url);

      //print('📥 Response status: ${response.statusCode}');
      //print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return StudentModel.fromJson(jsonData);
      } else {
        //print('❌ Failed to fetch student. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
     // print('❌ Exception in getStudentById: $e');
      return null;
    }
  }

  static Future<bool> toggleNameCorrection(String id, bool requested) async {
    try {
      final url = Uri.parse('$baseUrl/request-name-correction-toggle');
      final body = jsonEncode({'studentId': id, 'requested': requested});

      //print('📡 Toggling name correction: $body');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      //print('📥 Toggle response: ${response.statusCode} → ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      //print('❌ Exception in toggleNameCorrection: $e');
      return false;
    }
  }
}
