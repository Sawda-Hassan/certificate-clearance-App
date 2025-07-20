import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/group_clearance_model.dart';

class GroupClearanceService {
  final String baseUrl = 'http://10.0.2.2:5000/api/clearance';

  Future<GroupClearanceStatus> getClearanceStatus(String studentId) async {
    final response = await http.get(Uri.parse('$baseUrl/group-status/$studentId'));

    if (response.statusCode == 200) {
      return GroupClearanceStatus.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load group clearance status');
    }
  }
}
