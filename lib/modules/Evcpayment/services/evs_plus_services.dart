import 'dart:convert';
import 'package:http/http.dart' as http;

class EvsPlusServices {
  Future<Map<String, dynamic>> payByWaafiPay({
    required String studentId,
    required String phone,
    required double amount,
  }) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/finance/pay');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'studentId': studentId,
        'phone': phone,
        'amount': amount,
        'description': 'Graduation Fee Payment'
      }),
    );

    // ✅ Debug the raw response
    //print('🔁 WaafiPay Raw Response: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Payment failed: ${response.body}');
    }
  }
}
