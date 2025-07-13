import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/clearance_step.dart';

class ClearanceService {
  static const String baseUrl = 'http://localhost:5000/api/clearance';

  static Future<List<ClearanceStep>> getClearanceSteps(String studentId) async {
    final url = Uri.parse('$baseUrl/$studentId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List steps = jsonData['clearanceSteps'];
      return steps.map((e) => ClearanceStep.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load clearance steps');
    }
  }
}
