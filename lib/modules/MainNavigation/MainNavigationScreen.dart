import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../modules/FacultyClearancepage/FacultyClearancePage.dart';
import '../../modules/libraryclearance/view/library_clearance_page.dart';
import '../../modules/labclearance/view/lab_clearance_page.dart';
import '../../modules/profile/views/profile_screen.dart';
import '../../modules/chatbot/chatbot_screen.dart';
import '../../modules/notification/view/notification_screen.dart';
import '../../modules/MainNavigation/MainNavigationController.dart';

class MainNavigationScreen extends StatelessWidget {
  MainNavigationScreen({Key? key}) : super(key: key);

  final ctrl = Get.put(MainNavigationController());

  // ✅ REMOVE `const` since not all widgets support const constructors
  final List<Widget> pages = [
    FacultyClearancePage(),
    LibraryClearancePage(),
    NotificationScreen(),
    ProfileScreen(),
    ChatbotScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: ctrl.currentIndex.value,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ctrl.currentIndex.value,
            onTap: ctrl.switchTab,
            selectedItemColor: const Color(0xFF0A2647),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Status'),
              BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'Appointment'),
              BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chatbot'),
            ],
          ),
        ));
  }
}
