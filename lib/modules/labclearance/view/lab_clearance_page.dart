import 'package:flutter/material.dart' hide StepState;
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controller/lab_controller.dart';
import 'dart:async';

const _navy = Color(0xFF0A2647);
const _green = Color(0xFF35C651);
const _lightBlue = Color(0xFFE8F3FF);

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
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
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

Map<String, dynamic> labStatusLabel(String status) {
  switch (status) {
    case 'Approved':
      return {
        'label': 'Cleared',
        'color': _green,
        'icon': Icons.emoji_events,
        'msg': 'Your lab clearance is successfully cleared',
      };
    case 'Rejected':
      return {
        'label': 'Rejected',
        'color': Colors.red,
        'icon': Icons.cancel,
        'msg': 'Your lab clearance was rejected',
      };
    case 'Incomplete':
      return {
        'label': 'Incomplete',
        'color': Colors.deepOrange,
        'icon': Icons.warning,
        'msg': 'Your lab clearance is incomplete',
      };
    case 'Pending':
    default:
      return {
        'label': 'Pending',
        'color': Colors.orange,
        'icon': Icons.hourglass_empty,
        'msg': 'Your lab clearance is pending',
      };
  }
}

class LabClearancePage extends StatefulWidget {
  const LabClearancePage({Key? key}) : super(key: key);

  @override
  State<LabClearancePage> createState() => _LabClearancePageState();
}

class _LabClearancePageState extends State<LabClearancePage> {
  late LabController ctrl;
  Timer? _refreshTimer;
  bool _didAutoRefresh = false;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(LabController(), tag: 'lab');

    ctrl.connectSocket(ctrl.groupId ?? 'default-group');

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

      final isLabApproved = ctrl.status.value == 'Approved';
      final isLabRejected = ctrl.status.value == 'Rejected';
      final isLabIncomplete = ctrl.status.value == 'Incomplete';
      final progress = isLabApproved ? 0.6 : 0.4;
      final percentLabel = (progress * 100).round();

      final statusMap = labStatusLabel(ctrl.status.value);
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
                    Text(
                      'Lab Clearance Status',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                              decoration: BoxDecoration(color: _navy, shape: BoxShape.circle),
                              child: const Icon(Icons.science, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Lab',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: _navy),
                                  ),
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
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
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
                                  (isLabRejected || isLabIncomplete) && ctrl.issues.value.isNotEmpty
                                      ? ctrl.issues.value
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
                onPressed: isLabApproved
                    ? () => Get.offAllNamed('/finance-clearance')
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  backgroundColor: _navy,
                  disabledBackgroundColor: Colors.grey.shade400,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'PROCEED INDIVIDUAL CLEARANCE',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isLabApproved ? Colors.white : Colors.black38,
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
