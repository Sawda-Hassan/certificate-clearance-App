import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../model/examination_model.dart';

class ExaminationService {
  static final box = GetStorage();
  static const String baseUrl = 'http://10.0.2.2:5000/api/examination';

  static Future<EligibilityModel?> getExaminationStatus() async {
    final token = box.read('token');
    final studentId = box.read('studentId');

    if (token == null || studentId == null) {
      print('❌ Token or Student ID missing from storage');
      return null;
    }

    try {
      final url = Uri.parse('$baseUrl/check-eligibility/$studentId'); // ✅ Corrected route
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return EligibilityModel.fromJson(jsonData);
      } else {
        print('❌ Failed to load examination status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception in ExaminationService: $e');
      return null;
    }
  }
}
