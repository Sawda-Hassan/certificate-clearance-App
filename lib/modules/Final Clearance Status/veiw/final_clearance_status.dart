import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/clearance_controller.dart';
import '../../../widgets/curved_app_bar.dart';
import '../../../routes/app_routes.dart';
import '../../../modules/chatbot/chatbot_badge_controller.dart';
import '../../../modules/chatbot/chatbot_screen.dart';
import '../../auth/controllers/auth_controller.dart';
import ' ../../final_clearance_status.dart';
class FinalClearanceStatus extends StatefulWidget {
  const FinalClearanceStatus({super.key});

  @override
  State<FinalClearanceStatus> createState() => _FinalClearanceStatusState();
}

class _FinalClearanceStatusState extends State<FinalClearanceStatus> {
  final ClearanceController ctrl = Get.put(ClearanceController()); // ✅ moved out of initState
  late final String studentId;

  @override
  void initState() {
    super.initState();
    studentId = Get.find<AuthController>().loggedInStudent.value!.studentId;
    ctrl.loadClearance(studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: const CurvedAppBar(title: " Clearance Status"),
      bottomNavigationBar: const _BottomNav(),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: ctrl.steps.length,
                itemBuilder: (context, index) {
                  final step = ctrl.steps[index];
                  final isLast = index == ctrl.steps.length - 1;

                  return Stack(
                    children: [
                      Positioned(
                        left: 50,
                        top: 0,
                        bottom: isLast ? 30 : 0,
                        child: Container(
                          width: 2,
                          color: const Color(0xFF0A2647),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, bottom: 16),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 233, 226, 226),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A2647),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: Icon(
                                    _getIconForStep(step.title),
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                step.title.toUpperCase(),
                                style: TextStyle(
                                  fontSize: step.title.toLowerCase() == "finance" ? 12 : 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00C400),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                "cleared",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),

          /// ✅ Updated congratulations card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.emoji_events_outlined,
                    color: Color(0xFF00C400),
                    size: 28,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C400),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'You have successfully completed your certificate clearance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(221, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '📅 Please check your appointment date in the app for certificate collection.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForStep(String title) {
    switch (title.toLowerCase()) {
      case 'faculty':
        return Icons.account_balance;
      case 'library':
      case 'lab':
      case 'exam':
      case 'examination':
        return Icons.menu_book;
      case 'finance':
        return Icons.attach_money;
      default:
        return Icons.check_circle_outline;
    }
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final unread = Get.find<ChatbotBadgeController>().unreadCount;

    return Obx(() {
      return BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color.fromARGB(255, 33, 3, 102),
        unselectedItemColor: Colors.black.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            label: 'apointment',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Status',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset('assets/images/chat.png', width: 44, height: 44),
                if (unread.value > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: Image.asset('assets/images/ca.png', width: 24, height: 24),
            label: 'Chatbot',
          ),
        ],
     onTap: (index) {
  switch (index) {
    case 0:
      Get.offAllNamed(AppRoutes.appointment);
      break;
    case 1:
      Get.offAllNamed(AppRoutes.finalStatus); // ✅ Add this line
      break;
    case 2:
      Get.offAllNamed(AppRoutes.notification);
      break;
    case 3:
      Get.offAllNamed(AppRoutes.profile);
      break;
    case 4:
      Get.to(() => ChatbotScreen());
      break;
  }
});});}

    }
  