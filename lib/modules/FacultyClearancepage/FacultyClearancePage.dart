import 'package:flutter/material.dart' hide StepState;
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'controlerr/faculty_controller.dart';
import '../../routes/app_routes.dart';
import './model/faculty_models.dart';
import 'dart:async';

final ctrl = Get.put(FacultyController(), tag: 'faculty');

// Color palette
const _navy = Color(0xFF0A2647);
const _green = Color(0xFF35C651);
const _lightBlue = Color(0xFFE8F3FF);
const _borderColor = Color(0xFFE9EDF5);

// Wave-shaped AppBar clipper
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

// Curved AppBar widget
class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CurvedAppBar({Key? key, required this.title}) : super(key: key);

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
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(alignment: Alignment.topLeft, child: BackButton(color: Colors.white)),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Map backend status to label, color, icon, and message
Map<String, dynamic> facultyStatusLabel(String status) {
  switch (status) {
    case 'Approved':
      return {
        'label': 'Cleared',
        'color': _green,
        'icon': Icons.emoji_events,
        'msg': 'Your faculty clearance is successfully cleared',
      };
    case 'Rejected':
      return {
        'label': 'Rejected',
        'color': Colors.red,
        'icon': Icons.cancel,
        'msg': 'Your faculty clearance was rejected',
      };
    case 'Pending':
    default:
      return {
        'label': 'Pending',
        'color': Colors.orange,
        'icon': Icons.hourglass_empty,
        'msg': 'Your faculty clearance is pending',
      };
  }
}

class FacultyClearancePage extends StatefulWidget {
  const FacultyClearancePage({Key? key}) : super(key: key);

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
    // Listen for changes in the status and refresh once if still pending
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
      final statusIcon = statusMap['icon'] as IconData;
      final statusMsg = statusMap['msg'] as String;
      final statusLabel = statusMap['label'] as String;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CurvedAppBar(title: 'Group Clearance Status'),
        bottomNavigationBar: const _BottomNav(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Text(
                      'Faculty Clearance Status',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Status card (real status from backend)
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
                              child: const Icon(Icons.account_balance, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Faculty',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _navy),
                                  ),
                                  const SizedBox(height: 4),
                                ],
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
                    const SizedBox(height: 62),

                    // Status message (show rejection reason if exists)
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 460,
                          minWidth: 15,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _lightBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, color: statusColor, size: 18),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  statusLabel == 'Rejected' && ctrl.rejectionReason.value.isNotEmpty
                                      ? ctrl.rejectionReason.value
                                      : statusMsg,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: _navy,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),

                    // Progress label (NEW)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 15.0),
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

                    // Progress section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 114),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(49, 12, 49, 59),
              child: ElevatedButton(
onPressed: (ctrl.status.value == 'Approved')
    ? () {
        print('Navigating to Library Clearance!');
        Get.offAllNamed(AppRoutes.libraryClearance);
      }
    : null,



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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ctrl.status.value == 'Approved'? const Color.fromARGB(255, 255, 250, 250) : Colors.black38,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Bottom navigation bar
class _BottomNav extends StatelessWidget {
  const _BottomNav();
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: _navy,
      unselectedItemColor: Colors.black.withOpacity(0.5),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Status'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Get.offAllNamed('/student-welcome');
            break;
          case 1:
            break;
          case 2:
            Get.snackbar('Coming soon', 'Notification screen not implemented');
            break;
          case 3:
            Get.snackbar('Coming soon', 'Profile screen not implemented');
            break;
        }
      },
    );
  }
}
