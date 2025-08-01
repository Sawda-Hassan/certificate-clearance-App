import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import './chat_message_model.dart';
import './chatbot_service.dart';
import '../../socket_service.dart';
import './chatbot_badge_controller.dart';

class ChatbotController extends GetxController {
  final departments = ['general', 'faculty', 'library', 'lab', 'finance', 'exam_office'].obs;
  final currentDepartment = 'general'.obs;

  final allMessages = <ChatMessage>[].obs;
  final currentMessages = <ChatMessage>[].obs;

  final isBotTyping = false.obs;
  final isUserTyping = false.obs;

  final textController = TextEditingController();
  final scrollController = ScrollController();
  final ChatbotService _service = ChatbotService();

  @override
  void onInit() {
    super.onInit();

    // ✅ Fetch initial message history
    fetchMessages();

    // ✅ Get studentId from storage
    final box = GetStorage();
    final studentId = box.read('studentId');

    if (studentId == null) {
      print('❌ No studentId found in GetStorage');
      return;
    }

    // ✅ Join personal room to receive real-time messages
    SocketService().socket.emit('joinRoom', studentId);
    print('🔔 joinRoom emitted with ID: $studentId');

    // ✅ Listen to newMessage
    SocketService().waitUntilConnectedAndListen('newMessage', handleNewMessage);
    print('📱 Listening to newMessage event...');

    // ✅ Clear badge
    Future.microtask(() {
      if (Get.isRegistered<ChatbotBadgeController>()) {
        Get.find<ChatbotBadgeController>().clear();
      }
    });
  }

  void switchDepartment(String dept) {
    currentDepartment.value = dept;
    updateCurrentMessages();
    Future.delayed(const Duration(milliseconds: 100), scrollToBottom);
  }

  void updateCurrentMessages() {
    currentMessages.value = allMessages
        .where((msg) => msg.department == currentDepartment.value)
        .toList();
    print('📊 Updated currentMessages: ${currentMessages.length}');
  }

  void handleNewMessage(dynamic data) {
    try {
      final newMessage = ChatMessage.fromJson(data);
      print('📨 Socket: ${newMessage.message} | Dept: ${newMessage.department} | From: ${newMessage.senderType}');

      final alreadyExists = allMessages.any((m) => m.id == newMessage.id);
      if (!alreadyExists) {
        allMessages.add(newMessage);
        allMessages.refresh();
        updateCurrentMessages();
        Future.delayed(const Duration(milliseconds: 100), scrollToBottom);

        final normalizedDept = newMessage.department.toLowerCase().replaceAll(" ", "_");
        if (normalizedDept != currentDepartment.value && departments.contains(normalizedDept)) {
          currentDepartment.value = normalizedDept;
        }
      } else {
        print('🔁 Message already exists, skipped.');
      }
    } catch (e) {
      print('❌ Error in handleNewMessage: $e');
    }
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final department = currentDepartment.value;
    textController.clear();
    isUserTyping.value = true;

    try {
      final response = await _service.sendRawMessage(text, department: department);
      print('📥 Response received: $response');

      final studentMsg = response?['studentMessage'];
      if (studentMsg != null) {
        final msg = ChatMessage.fromJson(studentMsg);
        if (!allMessages.any((m) => m.id == msg.id)) {
          allMessages.add(msg);
          allMessages.refresh();
          updateCurrentMessages();
          Future.delayed(const Duration(milliseconds: 100), scrollToBottom);
        }
      }

      final botMsg = response?['botResponse'];
      if (botMsg != null) {
        isBotTyping.value = true;
        await Future.delayed(const Duration(milliseconds: 600));
        final reply = ChatMessage.fromJson(botMsg);
        if (!allMessages.any((m) => m.id == reply.id)) {
          allMessages.add(reply);
          allMessages.refresh();
          updateCurrentMessages();
        }

        isBotTyping.value = false;
        scrollToBottom();
      }
    } catch (e) {
      print('❌ Error sending message: $e');
    } finally {
      isUserTyping.value = false;
    }
  }

  void goBackToGeneral() {
    sendMessage("resolved");
  }

  void scrollToBottom() {
    if (!scrollController.hasClients) return;
    final offset = scrollController.position.maxScrollExtent;
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void fetchMessages() async {
    print('📥 Fetching messages...');
    final messages = await _service.getMessages();
    allMessages.clear();
    allMessages.addAll(messages);
    allMessages.refresh();
    updateCurrentMessages();
    print('✅ Loaded ${messages.length} messages');

    // Optional: log breakdown by dept
    final countsByDept = {
      for (var dept in departments)
        dept: messages.where((m) => m.department == dept).length
    };
    print('📊 Messages by dept: $countsByDept');
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
