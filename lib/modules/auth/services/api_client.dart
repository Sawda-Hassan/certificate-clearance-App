import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class ApiClient {
  static const String _base = 'http://10.0.2.2:5000/api';

  // Use GetStorage to retrieve the latest token every request
  final _box = GetStorage();

  /* --------------------------- POST --------------------------- */
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final url = '$_base$path';
    //print('🔗 [ApiClient] POST → $url');
    final res = await http.post(
      Uri.parse(url),
      headers: _headers(),
      body: jsonEncode(body ?? {}),
    );
    //print('⬅️ [ApiClient] POST $url ← status ${res.statusCode}');
    return _wrap(res);
  }

  /* ---------------------------- GET --------------------------- */
  Future<Map<String, dynamic>> get(String path) async {
    final url = '$_base$path';
    //print('🔗 [ApiClient] GET → $url');
    final res = await http.get(
      Uri.parse(url),
      headers: _headers(),
    );
    //print('⬅️ [ApiClient] GET $url ← status ${res.statusCode}');
    return _wrap(res);
  }

  /* ------------------------- Headers -------------------------- */
  Map<String, String> _headers() {
    final tokenValue = _box.read('token') ?? '';
    if (tokenValue.isEmpty) {
      //print('⚠️ [ApiClient] WARNING: token is EMPTY');
    } else {
      //print('🔑 [ApiClient] sending token: ${tokenValue.toString().substring(0, 20)}...');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenValue',
    };
  }

  /* ---------------------- Response Wrap ----------------------- */
  Map<String, dynamic> _wrap(http.Response res) {
    final code = res.statusCode;
    dynamic data;

    if (res.body.isNotEmpty) {
      try {
        data = jsonDecode(res.body);
      } catch (e) {
        //print('❌ [ApiClient] Failed to decode JSON: $e');
        data = null;
      }
    }

    return {
      'code': code,
      'data': data,
    };
  }
}
