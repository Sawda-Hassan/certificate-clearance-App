import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './chatbot_controller.dart';
import './message_bubble.dart';
import './option_buttons.dart';

class ChatbotScreen extends StatelessWidget {
  final controller = Get.put(ChatbotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: controller.scrollController, // ✅ Attach scroll
                  reverse: false,
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    print('📲 Rendering message: ${message.message}');
                    return MessageBubble(message: message);
                  },
                )),
          ),
          OptionButtons(onOptionSelected: controller.sendMessage),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    controller.sendMessage(controller.textController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
