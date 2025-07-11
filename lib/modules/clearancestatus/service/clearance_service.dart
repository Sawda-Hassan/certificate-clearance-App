// services/clearance_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClearanceService {
static const baseUrl = 'http://192.168.1.100:5000/api/clearance';

  static Future<String?> getCurrentClearanceStatus(String studentId) async {
    final url = Uri.parse('$baseUrl/$studentId');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        // Find first non-approved section
        final keys = ['faculty', 'library', 'lab', 'finance', 'examination'];
        for (final key in keys) {
          if (data[key]['status'] != 'Approved') return key;
        }
      }
    } catch (e) {
      //print('Error fetching clearance: $e');
    }
    return null;
  }
}
