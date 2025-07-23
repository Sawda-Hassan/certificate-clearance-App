import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/clearance_step.dart';

class ClearanceService {
  // Replace with your real IP address (not localhost!)
  static const String baseUrl = 'http://10.0.2.2:5000/api/clearance';

  // Fetches clearance steps for the student
  static Future<List<ClearanceStep>> getClearanceSteps(String studentId) async {
    final url = Uri.parse('$baseUrl/$studentId');
    print('📡 Fetching from: $url');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List steps = jsonData['clearanceSteps'];
      return steps.map((e) => ClearanceStep.fromJson(e)).toList();
    } else {
      print('❌ Backend Error: ${response.statusCode}');
      print('❌ Response Body: ${response.body}');
      throw Exception('Failed to load clearance steps');
    }
  }

  // Fetches the name correction status for the student
  static Future<NameCorrectionResponse> getNameCorrectionStatus(String studentId) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/student/$studentId/name-correction-status');
    print('📡 Fetching from: $url');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return NameCorrectionResponse.fromJson(jsonData);
    } else {
      print('❌ Backend Error: ${response.statusCode}');
      throw Exception('Failed to load name correction status');
    }
  }
}

// Model for name correction status response
class NameCorrectionResponse {
  final String status; // 'approved', 'pending', 'rejected'

  NameCorrectionResponse({required this.status});

  factory NameCorrectionResponse.fromJson(Map<String, dynamic> json) {
    return NameCorrectionResponse(status: json['status']);
  }
}
