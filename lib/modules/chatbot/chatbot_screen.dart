import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './chatbot_controller.dart';
import './message_bubble.dart';
import './option_buttons.dart';
import './TypingIndicatorDots.dart';

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

  final departmentIcons = {
    'general': Icons.home,
    'faculty': Icons.school,
    'library': Icons.library_books,
    'lab': Icons.science,
    'finance': Icons.account_balance_wallet,
    'exam_office': Icons.assignment,
  };

  void _showDepartmentMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Select Department',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            ...controller.departments.map((dept) => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: controller.currentDepartment.value == dept
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      departmentIcons[dept] ?? Icons.help,
                      color: controller.currentDepartment.value == dept
                          ? Colors.blue
                          : Colors.grey[600],
                    ),
                  ),
                  title: Text(
                    departmentLabels[dept] ?? dept,
                    style: TextStyle(
                      fontWeight: controller.currentDepartment.value == dept
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: controller.currentDepartment.value == dept
                          ? Colors.blue
                          : Colors.black87,
                    ),
                  ),
                  trailing: controller.currentDepartment.value == dept
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    controller.switchDepartment(dept);
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          "jamhuriya Assistant",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          Obx(() => controller.currentDepartment.value != 'general'
              ? IconButton(
                  onPressed: controller.goBackToGeneral,
                  icon: const Icon(Icons.arrow_back_ios),
                  tooltip: 'Back to General',
                )
              : const SizedBox.shrink()),
          IconButton(
            onPressed: _showDepartmentMenu,
            icon: const Icon(Icons.more_vert),
            tooltip: 'Select Department',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Department Banner
          Obx(() => controller.currentDepartment.value != 'general'
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.blue.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          departmentIcons[controller.currentDepartment.value] ?? Icons.help,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Connected to ${departmentLabels[controller.currentDepartment.value]}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              'You are now chatting with department staff',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.goBackToGeneral,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade500,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'End Chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink()),

          // Messages
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: controller.currentMessages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    message: controller.currentMessages[index],
                    showTime: controller.currentDepartment.value != 'general',
                  );
                },
              );
            }),
          ),

          // Typing Indicator
          Obx(() {
            if (controller.isBotTyping.value) {
              return Container(
                margin: const EdgeInsets.only(left: 16, bottom: 10),
                child: const Row(
                  children: [TypingIndicatorDots()],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Quick Reply Options (Hidden when in specific department)
          Obx(() => controller.currentDepartment.value == 'general'
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: OptionButtons(onOptionSelected: controller.sendMessage),
                )
              : const SizedBox.shrink()),

          const SizedBox(height: 10),

          // Input Field
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      border: InputBorder.none,
                    ),
                    onSubmitted: controller.sendMessage,
                    maxLines: null,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () => controller.sendMessage(controller.textController.text),
                    icon: const Icon(Icons.send, color: Colors.white),
                    splashRadius: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
