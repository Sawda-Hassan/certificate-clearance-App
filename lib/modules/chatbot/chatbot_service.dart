import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import './chat_message_model.dart';

class ChatbotService {
  final box = GetStorage();
  final String baseUrl = 'http://10.0.2.2:5000/api/chat';

  String get currentStudentId => box.read('id') ?? '';

  Future<List<ChatMessage>> getMessages() async {
    final response = await http.get(Uri.parse('$baseUrl/messages/$currentStudentId'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ChatMessage.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<ChatMessage?> sendMessage(String text) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderId': currentStudentId,
        'senderType': 'student',
        'message': text,
      }),
    );

    if (response.statusCode == 201) {
      return ChatMessage.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
