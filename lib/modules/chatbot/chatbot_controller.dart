import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './chat_message_model.dart';
import './chatbot_service.dart';
import '../../socket_service.dart';
import './chatbot_badge_controller.dart';

class ChatbotController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final textController = TextEditingController();
  final scrollController = ScrollController(); // ✅ For auto-scroll
  final ChatbotService _service = ChatbotService();

  @override
  void onInit() {
    super.onInit();

    fetchMessages();

    SocketService().on('newMessage', _handleNewMessage);
    print('📡 Socket listening for "newMessage"...');

    Future.microtask(() {
      if (Get.isRegistered<ChatbotBadgeController>()) {
        Get.find<ChatbotBadgeController>().clear();
        print('🔕 Chatbot opened → badge cleared');
      }
    });
  }

  void _handleNewMessage(dynamic data) {
    print('📩 newMessage received: $data');

    try {
      final newMessage = ChatMessage.fromJson(data);
      final alreadyExists = messages.any((m) => m.id == newMessage.id);

      if (!alreadyExists) {
        messages.add(newMessage);
        messages.refresh(); // ✅ Force UI update
        print('🆕 Message added → Total: ${messages.length}');

        // Scroll to latest
        Future.delayed(Duration(milliseconds: 100), () {
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        });

        if (Get.isRegistered<ChatbotBadgeController>()) {
          Get.find<ChatbotBadgeController>().increment();
          print('📛 Badge incremented');
        }
      }
    } catch (e) {
      print("❌ Error handling new message: $e");
    }
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    textController.clear();
    await _service.sendMessage(text);
    print('📤 Message sent to backend');
  }

  void fetchMessages() async {
    final all = await _service.getMessages();
    messages.assignAll(all);
    print('📚 Loaded ${all.length} past messages');

    Future.delayed(Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void onClose() {
    SocketService().off('newMessage', _handleNewMessage);
    textController.dispose();
    scrollController.dispose();
    super.onClose();
    print('🔌 ChatbotController disposed and socket listener removed');
  }
}
