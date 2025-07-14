import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/clearance_step.dart';

class ClearanceService {
  // Replace with your real IP address (not localhost!)
static const String baseUrl = 'http://10.0.2.2:5000/api/clearance';

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
}
