
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './chat_message_model.dart';
import './chatbot_service.dart';
import '../../socket_service.dart';

class ChatbotController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final textController = TextEditingController();
  final ChatbotService _service = ChatbotService();

  @override
  void onInit() {
    super.onInit();
    fetchMessages();

    // ✅ Listen for real-time messages from socket
    SocketService().on('newMessage', _handleNewMessage);
  }

  // ✅ Socket handler
  void _handleNewMessage(dynamic data) {
    try {
      final newMessage = ChatMessage.fromJson(data);

      // ✅ Prevent duplicates
      final alreadyExists = messages.any((m) => m.id == newMessage.id);
      if (!alreadyExists) {
        messages.add(newMessage);
      }
    } catch (e) {
      print("Socket message parse error: $e");
    }
  }

  // ✅ Send message (don't add to list, let socket handle it)
  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    textController.clear();
    await _service.sendMessage(text); // Socket will emit and add it
  }

  // ✅ Fetch all past messages
  void fetchMessages() async {
    final all = await _service.getMessages();
    messages.assignAll(all);
  }

  @override
  void onClose() {
    // ✅ Remove socket listener on dispose
    SocketService().off('newMessage', _handleNewMessage);
    textController.dispose();
    super.onClose();
  }
}
