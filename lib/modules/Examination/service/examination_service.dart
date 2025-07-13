import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../model/examination_model.dart';

class ExaminationService {
  static const baseUrl = 'http://10.0.2.2:5000/api/examination';

  static Future<EligibilityModel?> getExaminationStatus() async {
    final box = GetStorage();
    final studentId = box.read('studentId');

    if (studentId == null) {
      print('⚠️ No studentId in storage.');
      return null;
    }

    final url = Uri.parse('$baseUrl/status/$studentId'); // ✅ USE NEW ENDPOINT

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('🔥 Full response: $json');
        return EligibilityModel.fromJson(json);
      } else {
        print('❌ API error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exception in getExaminationStatus: $e');
      return null;
    }
  }
}
