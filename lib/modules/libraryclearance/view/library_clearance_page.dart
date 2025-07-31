import 'package:clearance_app/modules/profile/views/profile_screen.dart';
import 'package:flutter/material.dart' hide StepState;
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controller/library_controller.dart';
import '../../../widgets/ClearanceStepper.dart';
import '../../FacultyClearancepage/model/faculty_models.dart' as custom;
import '../../chatbot/chatbot_screen.dart';
import '../../chatbot/chatbot_badge_controller.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../widgets/curved_app_bar.dart';

const _navy = Color(0xFF0A2647);
const _green = Color(0xFF35C651);
const _lightBlue = Color(0xFFE8F3FF);

class LibraryClearancePage extends StatefulWidget {
  const LibraryClearancePage({Key? key}) : super(key: key);

  @override
  State<LibraryClearancePage> createState() => _LibraryClearancePageState();
}

class _LibraryClearancePageState extends State<LibraryClearancePage> {
  late LibraryController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(LibraryController(), tag: 'library');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final isLibraryApproved = ctrl.status.value == 'Approved';
      final isLibraryRejected = ctrl.status.value == 'Rejected';
      final progress = isLibraryApproved ? 0.4 : 0.2;
      final percentLabel = (progress * 100).round();

      final statusColor = isLibraryApproved
          ? _green
          : isLibraryRejected
              ? Colors.red
              : Colors.orange;

      final statusLabel = isLibraryApproved
          ? 'Cleared'
          : isLibraryRejected
              ? 'Rejected'
              : 'pending';

      final steps = [
        custom.ClearanceStep('Faculty', custom.StepState.approved),
        custom.ClearanceStep(
          'Library',
          isLibraryApproved
              ? custom.StepState.approved
              : isLibraryRejected
                  ? custom.StepState.rejected
                  : custom.StepState.pending,
        ),
        custom.ClearanceStep('Lab', custom.StepState.pending),
        custom.ClearanceStep('Finance', custom.StepState.pending),
        custom.ClearanceStep('Examination', custom.StepState.pending),
      ];

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CurvedAppBar(title: 'Library Clearance Status'),
        bottomNavigationBar: const _BottomNav(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color.fromARGB(255, 216, 221, 233)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: _navy, shape: BoxShape.circle),
                        child: const Icon(Icons.local_library, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Library',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _navy),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusLabel,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 🔔 Status Card like Faculty
              if (isLibraryApproved) ...[
                _statusCard(Icons.check_circle, '🎉 Congratulations!', 'Your library clearance is complete.', _green, bgColor: const Color(0xFFEAFBF1))
              ] else if (isLibraryRejected) ...[
                _statusCard(Icons.cancel, 'Rejected', ctrl.remarks.value.isNotEmpty ? ctrl.remarks.value : 'Your library clearance was rejected.', Colors.red, bgColor: const Color(0xFFFFEBEB))
              ] else ...[
                _statusCard(Icons.hourglass_top, 'In Progress', 'Your library clearance is under review.', Colors.orange, bgColor: _lightBlue)
              ],

              const SizedBox(height: 45),

              ClearanceStepper(steps: steps, progress: progress),
              const SizedBox(height: 40),

              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 15.0),
                child: Text(
                  'Progress...',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: LinearPercentIndicator(
                      lineHeight: 14,
                      percent: progress,
                      animation: true,
                      barRadius: const Radius.circular(30),
                      progressColor: statusColor,
                      backgroundColor: Colors.grey.shade400,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: 220,
                    top: -49,
                    child: CircularPercentIndicator(
                      radius: 20,
                      lineWidth: 6,
                      percent: progress,
                      animation: true,
                      progressColor: statusColor,
                      backgroundColor: Colors.grey.shade300,
                      center: Text(
                        '$percentLabel%',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Completed $percentLabel% of your certificate clearance',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.fromLTRB(49, 12, 49, 40),
                child: ElevatedButton(
                  onPressed: isLibraryApproved ? () => Get.offAllNamed('/lab') : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                    backgroundColor: _navy,
                    disabledBackgroundColor: Colors.grey.shade400,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'PROCEED LAB CLEARANCE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isLibraryApproved ? Colors.white : Colors.black38,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ✅ Add this inside the class to fix the _statusCard error
  Widget _statusCard(IconData icon, String title, String msg, Color color, {Color? bgColor}) {
    return Container(
      decoration: BoxDecoration(color: bgColor ?? _lightBlue, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(msg, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final unread = Get.find<ChatbotBadgeController>().unreadCount.value;

    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: _navy,
      unselectedItemColor: Colors.black.withOpacity(0.5),
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
        const BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Status'),
        const BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset('assets/images/chat.png', width: 44, height: 44),
              if (unread > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
            Get.offAllNamed('/student-welcome');
            break;
          case 3:
            Get.to(() => ProfileScreen(), arguments: {'returnToRoute': AppRoutes.libraryClearance});
            break;
          case 4:
            Get.to(() => ChatbotScreen(), arguments: {'returnToRoute': AppRoutes.libraryClearance});
            break;
        }
      },
    );
  }
}
