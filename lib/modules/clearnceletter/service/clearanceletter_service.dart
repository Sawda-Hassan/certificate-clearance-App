import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/clearanceletter_model.dart';

class ClearanceLetterService {
  static Future<ClearanceLetterModel> fetchClearanceLetter(String studentId) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/clearanceletter/$studentId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ClearanceLetterModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch clearance letter data');
    }
  }
}
