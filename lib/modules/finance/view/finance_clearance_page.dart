import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controller/finance_controller.dart';
import '../../../routes/app_routes.dart';
import '../../chatbot/chatbot_floating_button.dart';
import '../../notification/view/notification_screen.dart';
import '../../chatbot/chatbot_screen.dart';
import '../../chatbot/chatbot_badge_controller.dart';
import '../../labclearance/view/lab_clearance_page.dart';
import '../../../widgets/ClearanceStepper.dart';
import '../../FacultyClearancepage/model/faculty_models.dart' as custom;

const _navy = Color(0xFF0A2647);
const _green = Color(0xFF35C651);
const _lightBlue = Color(0xFFE8F3FF);

class FinanceClearancePage extends StatefulWidget {
  const FinanceClearancePage({Key? key}) : super(key: key);

  @override
  State<FinanceClearancePage> createState() => _FinanceClearancePageState();
}

class _FinanceClearancePageState extends State<FinanceClearancePage> {
  late FinanceController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(FinanceController(), tag: 'finance');
    final sid = ctrl.box.read('studentId');
    if (sid != null && sid.toString().isNotEmpty) {
      // Use post-frame callback to load status after the current build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ctrl.loadStatus(sid);
        ctrl.connectSocket(sid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final unpaid = ctrl.unpaidAmount.value;
      final isCleared = unpaid <= 0.001;
      final progress = isCleared ? 0.8 : 0.6;
      final percentLabel = (progress * 100).round();
      final statusColor = isCleared ? _green : Colors.orange;
      final statusLabel = isCleared ? 'Cleared' : 'Pending';

      final steps = [
        custom.ClearanceStep('Faculty', custom.StepState.approved),
        custom.ClearanceStep('Library', custom.StepState.approved),
        custom.ClearanceStep('Lab', custom.StepState.approved),
        custom.ClearanceStep(
          'Finance',
          isCleared ? custom.StepState.approved : custom.StepState.pending,
        ),
        custom.ClearanceStep('Examination', custom.StepState.pending),
      ];

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CurvedAppBar(title: 'Individual Clearance Status', backToLab: true),
        bottomNavigationBar: const _BottomNav(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Finance Clearance Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _navy),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Color.fromARGB(255, 216, 221, 233)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: _navy, shape: BoxShape.circle),
                              child: const Icon(Icons.attach_money, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Finance',
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
                    const SizedBox(height: 20),
                    if (!isCleared)
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 62),
                          decoration: BoxDecoration(
                            color: _lightBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 12, bottom: 8),
                                decoration: const BoxDecoration(
                                  color: _navy,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 14,
                                    child: Icon(Icons.warning_amber_rounded,
                                        size: 18, color: Colors.orange.shade700),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'lacag baa laguu leeyahay ${unpaid.toStringAsFixed(3)}',
                                style: const TextStyle(
                                  color: _navy,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'would like to pay !',
                                style: TextStyle(
                                  color: _navy,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ElevatedButton(
                                onPressed: () => Get.toNamed(AppRoutes.financePayment),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('PAY', style: TextStyle(fontSize: 12)),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                    ClearanceStepper(steps: steps, progress: progress),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 15.0),
                      child: Text(
                        'Progress...',
                        style: TextStyle(color: _navy, fontSize: 17, fontWeight: FontWeight.bold),
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
                                  fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Completed $percentLabel% of your certificate clearance',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(49, 12, 49, 59),
              child: ElevatedButton(
                onPressed: isCleared ? () => Get.offAllNamed(AppRoutes.examClearance) : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  backgroundColor: isCleared ? _navy : Colors.grey.shade400,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'PROCEED EXAM CLEARANCE',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isCleared ? Colors.white : Colors.black38),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backToLab;
  const CurvedAppBar({Key? key, required this.title, this.backToLab = false}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _AppBarWaveClipper(),
      child: Container(
        height: preferredSize.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF022A42), Color(0xFF2E1B61)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 6, left: 16, right: 16),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (backToLab) {
                      Get.off(() => const LabClearancePage());
                    } else {
                      Get.back();
                    }
                  },
                ),
              ),
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..lineTo(0, size.height * .75)
    ..quadraticBezierTo(size.width * .25, size.height, size.width * .5, size.height * .9)
    ..quadraticBezierTo(size.width * .75, size.height * .8, size.width, size.height * .9)
    ..lineTo(size.width, 0)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  static const _navy = Color.fromARGB(255, 33, 3, 102);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final unread = Get.find<ChatbotBadgeController>().unreadCount.value;

      return BottomNavigationBar(
        currentIndex: 0, // Set this dynamically depending on screen
        selectedItemColor: _navy,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Status',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Appointment',
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
                Image.asset('assets/images/chat.png', width: 32, height: 32),
                if (unread > 0)
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
              // Status page (current)
              break;
            case 1:
              Get.toNamed('/appointment'); // ✅ appointment route
              break;
            case 2:
              Get.toNamed('/notifications');
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
