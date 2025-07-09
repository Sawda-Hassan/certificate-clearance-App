import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../routes/app_routes.dart';
import 'controlerr/faculty_controller.dart';
import './model/faculty_models.dart' as custom;
import '../../modules/chatbot/chatbot_floating_button.dart';
import '../../modules/notification/view/notification_screen.dart';
import '../../modules/chatbot/chatbot_screen.dart';
import '../chatbot/chatbot_badge_controller.dart';

const _navy = Color(0xFF0A2647);
const _green = Color(0xFF35C651);
const _lightBlue = Color(0xFFE8F3FF);

class FacultyClearancePage extends StatefulWidget {
  const FacultyClearancePage({super.key});

  @override
  State<FacultyClearancePage> createState() => _FacultyClearancePageState();
}

class _FacultyClearancePageState extends State<FacultyClearancePage> {
  late FacultyController ctrl;
  Timer? _refreshTimer;
  bool _didAutoRefresh = false;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(FacultyController(), tag: 'faculty');

    ever<String>(ctrl.status, (status) async {
      if (!_didAutoRefresh && status == 'Pending') {
        _refreshTimer?.cancel();
        _refreshTimer = Timer(const Duration(seconds: 5), () async {
          await ctrl.loadStatus();
          _didAutoRefresh = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final progress = ctrl.percent.clamp(0.0, 1.0);
      final percentLabel = (progress * 100).round();
      final statusMap = facultyStatusLabel(ctrl.status.value);
      final statusColor = statusMap['color'] as Color;
      final statusLabel = statusMap['label'] as String;

      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: const CurvedAppBar(title: 'Group Clearance Status'),
        bottomNavigationBar: const _BottomNav(),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              physics: constraints.maxHeight > 700 ? const NeverScrollableScrollPhysics() : null,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Faculty Clearance Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 48),

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
                              decoration: const BoxDecoration(color: _navy, shape: BoxShape.circle),
                              child: const Icon(Icons.account_balance, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Faculty',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _navy),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                              decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(8)),
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

                    if (statusLabel == 'Cleared') ...[
                      _statusCard(Icons.check_circle, '🎉 Congratulations!', 'Your faculty clearance is complete.', _green, bgColor: const Color(0xFFEAFBF1))
                    ] else if (statusLabel == 'Pending') ...[
                      _statusCard(Icons.hourglass_top, '⏳ In Progress', 'Your faculty clearance is under review.', Colors.orange, bgColor: _lightBlue)
                    ] else if (statusLabel == 'Rejected') ...[
                      _statusCard(Icons.cancel, '❌ Rejected', ctrl.rejectionReason.value.isNotEmpty ? ctrl.rejectionReason.value : 'Your faculty clearance was rejected. Please review and resubmit.', Colors.red, bgColor: const Color(0xFFFFEBEB))
                    ] else if (statusLabel == 'Incomplete') ...[
                      _statusCard(Icons.warning_amber_rounded, '⚠️ Incomplete', ctrl.rejectionReason.value.isNotEmpty ? ctrl.rejectionReason.value : 'Your faculty clearance is marked as incomplete. Please submit the required documents.', Colors.deepPurple, bgColor: const Color(0xFFF3F0FF))
                    ],

                    const SizedBox(height: 40),
                    const Text('Progress...', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _navy)),
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
                            center: Text('$percentLabel%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        
                      ],
                      
                    ),
                    const SizedBox(height: 10),
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


                    const SizedBox(height: 36),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            top: 14,
                            left: 0,
                            right: 0,
                            child: Container(height: 2, color: Colors.grey.shade300),
                          ),
                          Positioned(
                            top: 14,
                            left: 0,
                            right: MediaQuery.of(context).size.width * (1 - progress),
                            child: Container(height: 2, color: _green),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ctrl.steps.map((custom.ClearanceStep step) {
                              final isCleared = step.state == custom.StepState.approved;
                              return Column(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: isCleared ? _green : const Color.fromARGB(255, 15, 1, 95),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isCleared ? _green : Colors.grey.shade400,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Icon(
                                      isCleared ? Icons.check : Icons.lock,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    step.label.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isCleared ? Colors.black : Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 56),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(49, 12, 49, 59),
                      child: ElevatedButton(
                        onPressed: (ctrl.status.value == 'Approved') ? () => Get.offAllNamed(AppRoutes.libraryClearance) : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(60),
                          backgroundColor: _navy,
                          disabledBackgroundColor: Colors.grey.shade400,
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'PROCEED LIBRARY CLEARANCE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: ctrl.status.value == 'Approved' ? Colors.white : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _statusCard(IconData icon, String title, String msg, Color color, {Color? bgColor}) {
    return Container(
      decoration: BoxDecoration(color: bgColor ?? _lightBlue, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
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

Map<String, dynamic> facultyStatusLabel(String status) {
  switch (status) {
    case 'Approved':
      return {'label': 'Cleared', 'color': _green, 'icon': Icons.emoji_events};
    case 'Rejected':
      return {'label': 'Rejected', 'color': Colors.red, 'icon': Icons.cancel};
    case 'Incomplete':
      return {'label': 'Incomplete', 'color': Colors.orangeAccent, 'icon': Icons.warning_amber_rounded};
    case 'Pending':
    default:
      return {'label': 'Pending', 'color': Colors.orange, 'icon': Icons.hourglass_empty};
  }
}

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CurvedAppBar({super.key, required this.title});

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
            colors: [Color(0xFF023B70), Color(0xFF1C2E63)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              const Align(alignment: Alignment.topLeft, child: BackButton(color: Colors.white)),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
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
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          const BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Status'),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset('assets/images/chatbot_icon.png', width: 34, height: 34),
                if (unread > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
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
