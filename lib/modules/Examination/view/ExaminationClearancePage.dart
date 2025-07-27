import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controller/examination_controller.dart';
import '../../../routes/app_routes.dart';
import '../../chatbot/chatbot_badge_controller.dart';
import '../../chatbot/chatbot_screen.dart';
import '../../../widgets/ClearanceStepper.dart';
import '../../../widgets/curved_app_bar.dart';
import '../../FacultyClearancepage/model/faculty_models.dart' as custom;

const _navy = Color(0xFF0A2647);
const _green = Color(0xFF35C651);
const _lightBlue = Color(0xFFE8F3FF);
const _orange = Colors.orange;

Map<String, dynamic> examStatusLabel(String status) {
  switch (status) {
    case 'Approved':
      return {
        'label': 'Cleared',
        'color': _green,
        'icon': Icons.verified,
      };
    case 'Rejected':
      return {
        'label': 'Pending', // Treat "Rejected" as Pending in UI
        'color': _orange,
        'icon': Icons.hourglass_empty,
      };
    default:
      return {
        'label': 'Pending',
        'color': _orange,
        'icon': Icons.hourglass_empty,
      };
  }
}

class ExaminationClearancePage extends StatelessWidget {
  final ctrl = Get.put(ExaminationController(), tag: 'exam');

  ExaminationClearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final isApproved = ctrl.status.value == 'Approved';
      final steps = [
        custom.ClearanceStep('Faculty', custom.StepState.approved),
        custom.ClearanceStep('Library', custom.StepState.approved),
        custom.ClearanceStep('Lab', custom.StepState.approved),
        custom.ClearanceStep('Finance', custom.StepState.approved),
        custom.ClearanceStep(
          'Examination',
          isApproved ? custom.StepState.approved : custom.StepState.pending,
        ),
      ];

      final completedSteps = isApproved ? 5 : 4;
      final progress = completedSteps / 5;
      final percentLabel = (progress * 100).round();

      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: const CurvedAppBar(
          title: 'Individual Clearance Status',
          backToFinance: true,
        ),
        bottomNavigationBar: const BottomNav(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ✅ Reactive Status & Message Box
              Obx(() {
                final status = ctrl.status.value;
                final failedCourses = ctrl.failedCourses;
                final statusMap = examStatusLabel(status);
                final color = statusMap['color'];
                final label = statusMap['label'];
                final icon = statusMap['icon'];

                final msg = failedCourses.isNotEmpty
                    ? "You're almost there! Once you've successfully completed ${failedCourses.join(", ")}, you'll be eligible."
                    : 'Now you are eligible for certificate collection.';

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: _navy,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.school, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Examination',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.05),
                        border: Border.all(color: color),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: color),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              msg,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 80),
              ClearanceStepper(steps: steps, progress: progress),
              const SizedBox(height: 60),

              const Text(
                'Progress',
                style: TextStyle(
                    color: _navy, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

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
                      progressColor: isApproved ? _green : _orange,
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
                      progressColor: isApproved ? _green : _orange,
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
              const SizedBox(height: 14),
              Text(
                'Completed $percentLabel% of your certificate clearance',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 39),

              Obx(() => ElevatedButton(
                    onPressed: ctrl.status.value == 'Approved'
                        ? () => Get.toNamed(AppRoutes.nameCorrection)
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(70),
                      backgroundColor: ctrl.status.value == 'Approved'
                          ? _navy
                          : Colors.grey[300],
                    ),
                    child: Text(
                      'PROCEED NAME CORRECTION',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ctrl.status.value == 'Approved'
                            ? Colors.white
                            : Colors.black45,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      );
    });
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final unread = Get.find<ChatbotBadgeController>().unreadCount.value;

      return BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: _navy,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'HOME'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: 'Status'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notification'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset('assets/images/chat.png', width: 44, height: 44),
                if (unread > 0)
                  const Positioned(
                    top: -2,
                    right: -2,
                    child: CircleAvatar(radius: 5, backgroundColor: Colors.red),
                  ),
              ],
            ),
            activeIcon:
                Image.asset('assets/images/ca.png', width: 24, height: 24),
            label: 'Chatbot',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/student-welcome');
              break;
            case 3:
              Get.offAllNamed(AppRoutes.profile);
              break;
            case 4:
              Get.to(() => ChatbotScreen());
              break;
          }
        },
      );
    });
  }
}
