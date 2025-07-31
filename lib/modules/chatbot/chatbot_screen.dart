import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './chatbot_controller.dart';
import './message_bubble.dart';
import './option_buttons.dart';
import './TypingIndicatorDots.dart';
import '../../socket_service.dart';
import '../../routes/app_routes.dart';
class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final controller = Get.put(ChatbotController());

  final departmentLabels = {
    'general': 'General',
    'faculty': 'Faculty',
    'library': 'Library',
    'lab': 'Lab',
    'finance': 'Finance',
    'exam_office': 'Examination',
  };

  @override
  void initState() {
    super.initState();
    // ✅ Ensure socket is connected and listener is reattached
    SocketService().off('newMessage');
    SocketService().on('newMessage', controller.handleNewMessage);
    print('🔁 Reattached socket listener in ChatbotScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jamhuriya Assistant" ),
        backgroundColor: Colors.deepPurple,
        actions: [
          Obx(() => controller.currentDepartment.value != 'general'
              ? IconButton(
 onPressed: () {
      final route = Get.arguments?['returnToRoute'] ?? AppRoutes.finalStatus;
      Get.offAllNamed(route);
    },                  icon: const Icon(Icons.home),
                  tooltip: 'Back to General',
                )
              : const SizedBox.shrink()),
          Obx(() => DropdownButton<String>(
                value: controller.currentDepartment.value,
                dropdownColor: Colors.deepPurple[100],
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                items: controller.departments
                    .map((dept) => DropdownMenuItem<String>(
                          value: dept,
                          child: Text(
                            departmentLabels[dept] ?? dept,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) controller.switchDepartment(value);
                },
              )),
        ],
      ),
      body: Column(
        children: [
          // Department Banner
          Obx(() => controller.currentDepartment.value != 'general'
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.deepPurple.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        'Connected to ${departmentLabels[controller.currentDepartment.value]}',
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: controller.goBackToGeneral,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'End Chat',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),

          // ✅ Messages List
          Expanded(
            child: Obx(() {
              final messages = controller.currentMessages;
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(message: messages[index]);
                },
              );
            }),
          ),

          // Typing Indicator
          Obx(() {
            if (controller.isBotTyping.value) {
              return const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 10),
                child: Row(children: [TypingIndicatorDots()]),
              );
            }
            return const SizedBox.shrink();
          }),

          // Quick Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: OptionButtons(onOptionSelected: controller.sendMessage),
          ),
          const SizedBox(height: 10),

          // Input Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onSubmitted: controller.sendMessage,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () => controller.sendMessage(controller.textController.text),
                  icon: const Icon(Icons.send),
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
