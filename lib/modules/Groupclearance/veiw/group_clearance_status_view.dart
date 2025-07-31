import 'package:clearance_app/modules/appointments/views/appointment_page.dart';
import 'package:clearance_app/modules/notification/view/notification_screen.dart';
import 'package:clearance_app/modules/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controller/group_clearance_controller.dart';
import '../../../widgets/curved_app_bar.dart';
import '../../../widgets/ClearanceStepper.dart';
import '../../FacultyClearancepage/model/faculty_models.dart' as custom;

class GroupClearanceStatusPage extends StatefulWidget {
  const GroupClearanceStatusPage({super.key});

  @override
  State<GroupClearanceStatusPage> createState() => _GroupClearanceStatusPageState();
}

class _GroupClearanceStatusPageState extends State<GroupClearanceStatusPage> {
  final GroupClearanceController ctrl = Get.put(GroupClearanceController());
  late final String studentId;

  static const _navy = Color(0xFF0A2647);
  static const _green = Color(0xFF35C651);

  @override
  void initState() {
    super.initState();
    studentId = Get.find<AuthController>().loggedInStudent.value!.studentId;
    ctrl.loadClearanceStatus(studentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: const CurvedAppBar(
        title: "Group Clearance Status",
        backToFinance: false,
      ),
      bottomNavigationBar: const _BottomNav(),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final status = ctrl.clearanceStatus.value!;
        final departments = status.departments;
        final clearedCount = departments.values.where((s) => s == 'Approved').length;

        final steps = [
          custom.ClearanceStep('Faculty', custom.StepState.approved),
          custom.ClearanceStep('Library', custom.StepState.approved),
          custom.ClearanceStep('Lab', custom.StepState.approved),
          custom.ClearanceStep('Finance', custom.StepState.pending),
          custom.ClearanceStep('Examination', custom.StepState.pending),
        ];

        final progress = clearedCount / 5;
        final percentLabel = (progress * 100).round();

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Department List
                ...departments.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getIcon(entry.key),
                          size: 30,
                          color: _navy,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Text(
                            "cleared",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 30),

                // Stepper
                ClearanceStepper(steps: steps, progress: progress),

                const SizedBox(height: 50),

                // Celebration Message
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 221, 250, 214),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color.fromARGB(255, 39, 252, 57), width: 1),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.celebration, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Group phase clearance completed successfully.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 3, 22, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Progress...',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Progress Bar
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
                        progressColor: _green,
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
                        progressColor: _green,
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

                const SizedBox(height: 10),

                Text(
                  'Completed $percentLabel% of your certificate clearance',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 30),

                // Action Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.financeClearance);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _navy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
                    ),
                    child: const Text(
                      "PROCEED INDIVIDUAL CLEARANCE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  IconData _getIcon(String title) {
    switch (title.toLowerCase()) {
      case 'faculty':
        return Icons.account_balance;
      case 'library':
        return Icons.menu_book;
      case 'lab':
        return Icons.computer;
      default:
        return Icons.check_circle;
    }
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: const Color(0xFF0A2647),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Status'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
        BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'Appointment'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAllNamed(AppRoutes.home);
            break;
          case 1:
          Get.to(() =>  GroupClearanceStatusPage(), arguments: {'returnToRoute': AppRoutes.groupClearanceStatus});

            break;
          case 2:
      Get.to(() => const NotificationScreen(), arguments: {'returnToRoute': AppRoutes.groupClearanceStatus});
            break;
          case 3:
        Get.to(() =>  AppointmentPage(), arguments: {'returnToRoute': AppRoutes.groupClearanceStatus});

            break;
          case 4:
      Get.to(() =>  ProfileScreen(), arguments: {'returnToRoute': AppRoutes.groupClearanceStatus});
            break;
        }
      },
    );
  }
}
