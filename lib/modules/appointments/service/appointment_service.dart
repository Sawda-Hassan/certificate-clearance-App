import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/appointment_model.dart';

class AppointmentService {
  static const String baseHost = "http://10.0.2.2:5000/api/appointments";

  static Future<AppointmentModel?> fetchAppointmentByStudent(String studentId) async {
    final url = Uri.parse("$baseHost/student/$studentId");
    //print("📡 Fetching appointment for studentId: $studentId"); // Debug

    final response = await http.get(url);

    //print("📥 Response status: ${response.statusCode}");
    //print("📥 Response body: ${response.body}"); // Debug

    if (response.statusCode == 200) {
      return AppointmentModel.fromJson(jsonDecode(response.body));
    } else {
      //print("❌ Failed to fetch appointment: ${response.reasonPhrase}");
      return null;
    }
  }

  static Future<bool> checkIn(String studentId) async {
    final url = Uri.parse("$baseHost/student/$studentId/check-in");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentId": studentId}),
    );

    return response.statusCode == 200;
  }

  static Future<bool> reschedule(String studentId, String newDate, String reason) async {
    final url = Uri.parse("$baseHost/student/$studentId/reschedule");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "studentId": studentId,
        "newDate": newDate,
        "reason": reason,
      }),
    );

    return response.statusCode == 200;
  }
}
