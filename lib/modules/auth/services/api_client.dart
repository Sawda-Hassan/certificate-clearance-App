// lib/modules/auth/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';      // adjust path if different

class ApiClient {
  // 👇 Change only the base part to match your server & port
  static const String _base = 'http://10.0.2.2:5000/api';

  final _auth = Get.find<AuthController>();        // need AuthController registered

  /* --------------------------- POST --------------------------- */
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final res = await http.post(
      Uri.parse('$_base$path'),
      headers: _headers(),
      body: jsonEncode(body ?? {}),
    );
    return _wrap(res);
  }

  /* ---------------------------- GET --------------------------- */
  Future<Map<String, dynamic>> get(String path) async {
    final res = await http.get(
      Uri.parse('$_base$path'),
      headers: _headers(),
    );
    return _wrap(res);
  }

  /* ------------------------- helpers -------------------------- */
  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_auth.token}',
      };

  Map<String, dynamic> _wrap(http.Response res) => {
        'code': res.statusCode,
        'data': res.body.isEmpty ? null : jsonDecode(res.body),
      };
}
