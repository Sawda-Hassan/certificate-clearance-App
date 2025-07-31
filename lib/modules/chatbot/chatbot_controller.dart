import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './chat_message_model.dart';
import './chatbot_service.dart';
import '../../socket_service.dart';
import './chatbot_badge_controller.dart';

class ChatbotController extends GetxController {
  final departments = ['general', 'faculty', 'library', 'lab', 'finance', 'exam_office'].obs;
  final currentDepartment = 'general'.obs;

  final allMessages = <ChatMessage>[].obs;
  final isBotTyping = false.obs;
  final isUserTyping = false.obs;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  final ChatbotService _service = ChatbotService();

  @override
  void onInit() {
    super.onInit();
    fetchMessages();

    // ✅ Listen for new messages
    SocketService().on('newMessage', handleNewMessage);
    print('📡 Socket listening for "newMessage"...');

    // ✅ Clear badge
    Future.microtask(() {
      if (Get.isRegistered<ChatbotBadgeController>()) {
        Get.find<ChatbotBadgeController>().clear();
      }
    });
  }

  List<ChatMessage> get currentMessages {
    return allMessages.where((msg) => msg.department == currentDepartment.value).toList();
  }

  void switchDepartment(String dept) {
    currentDepartment.value = dept;
    scrollToBottom();
  }

  void handleNewMessage(dynamic data) {
    try {
      final newMessage = ChatMessage.fromJson(data);
      print('📨 Received message: ${newMessage.message} | From: ${newMessage.senderType}');

      final alreadyExists = allMessages.any((m) => m.id == newMessage.id);
      if (!alreadyExists) {
        allMessages.add(newMessage);
        allMessages.refresh();

        if (newMessage.department == currentDepartment.value) {
          scrollToBottom();
        }
      }
    } catch (e) {
      print("❌ Error handling new message: $e");
    }
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final trimmed = text.trim();
    textController.clear();
    isUserTyping.value = true;

    try {
      final response = await _service.sendRawMessage(trimmed, department: currentDepartment.value);

      // ✅ Add student message manually
      if (response != null && response['studentMessage'] != null) {
        final msg = ChatMessage.fromJson(response['studentMessage']);
        allMessages.add(msg);
        allMessages.refresh();
        print("✅ Added student message immediately: ${msg.message}");
        scrollToBottom();

        // Auto-switch if routing occurred
        if (msg.department != currentDepartment.value &&
            departments.contains(msg.department)) {
          currentDepartment.value = msg.department;
          print('🔁 Switched to ${msg.department}');
        }
      }

      // ✅ Add bot response if exists
      if (response != null && response['botResponse'] != null) {
        isBotTyping.value = true;
        await Future.delayed(const Duration(milliseconds: 600));
        final reply = ChatMessage.fromJson(response['botResponse']);
        allMessages.add(reply);
        allMessages.refresh();
        isBotTyping.value = false;

        if (reply.department != currentDepartment.value &&
            departments.contains(reply.department)) {
          currentDepartment.value = reply.department;
          print('🔁 Switched to ${reply.department} (from bot)');
        }

        scrollToBottom();
      }
    } catch (e) {
      print('❌ Error sending message: $e');
    } finally {
      isUserTyping.value = false;
      allMessages.refresh();
    }
  }

  void goBackToGeneral() {
    sendMessage('resolved');
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void fetchMessages() async {
    final messages = await _service.getMessages();
    allMessages.clear();
    allMessages.addAll(messages);
    allMessages.refresh();
    scrollToBottom();
  }

  @override
  void onClose() {
    SocketService().off('newMessage', handleNewMessage);
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
