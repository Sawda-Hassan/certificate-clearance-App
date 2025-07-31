import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import './chat_message_model.dart';

class ChatbotService {
  final box = GetStorage();
final String baseUrl = 'http://10.39.78.218:5000/api/chat';

  /// 🔑 Get the currently logged in student ID from local storage
  String get currentStudentId => box.read('id') ?? '';

  /// 📩 Fetch all messages for the student
  Future<List<ChatMessage>> getMessages() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/messages/$currentStudentId'));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ChatMessage.fromJson(e)).toList();
      } else {
        print('❌ Failed to fetch messages: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Exception while fetching messages: $e');
      return [];
    }
  }

  /// ✉ Send a message with a given department (used in ChatbotController)
  Future<Map<String, dynamic>?> sendRawMessage(String text,
      {required String department}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'senderId': currentStudentId,
          'senderType': 'student',
          'message': text,
          'department': department,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('❌ Failed to send message: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception while sending message: $e');
      return null;
    }
  }
}