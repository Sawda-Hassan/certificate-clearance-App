import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controller/examination_controller.dart';
import '../../../routes/app_routes.dart';

const _navy = Color(0xFF0A2647);
const _green = Color(0xFF35C651);
const _lightBlue = Color(0xFFE8F3FF);

// ---- Status Map ----
Map<String, dynamic> examStatusLabel(String status) {
  switch (status) {
    case 'Approved':
      return {
        'label': 'Cleared',
        'color': _green,
        'icon': Icons.verified,
        'msg': 'Now You are eligible for certificate collection.',
      };
    case 'Rejected':
      return {
        'label': 'Rejected',
        'color': Colors.red,
        'icon': Icons.cancel,
        'msg': 'Your examination clearance was rejected',
      };
    case 'Pending':
    default:
      return {
        'label': 'Pending',
        'color': Colors.orange,
        'icon': Icons.hourglass_empty,
        'msg': 'Your examination clearance is pending',
      };
  }
}

// ---- Curved AppBar ----
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

// ---- Main Page ----
class ExaminationClearancePage extends StatefulWidget {
  const ExaminationClearancePage({Key? key}) : super(key: key);

  @override
  State<ExaminationClearancePage> createState() => _ExaminationClearancePageState();
}

class _ExaminationClearancePageState extends State<ExaminationClearancePage> {
  late ExaminationController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(ExaminationController(), tag: 'exam');
    ctrl.fetchExaminationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final isApproved = ctrl.status.value == 'Approved';
      final isRejected = ctrl.status.value == 'Rejected';
      final progress = isApproved ? 1.0 : 0.8; // ✅ 100% if approved, else 80%
      final percentLabel = (progress * 100).round();

      final statusMap = examStatusLabel(ctrl.status.value);
      final statusColor = statusMap['color'];
      final statusIcon = statusMap['icon'];
      final statusLabel = statusMap['label'];
      final statusMsg = statusMap['msg'];

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CurvedAppBar(title: 'Individual Clearance Status'),
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
                      'Examination Clearance Status',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Status Card
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
                              child: const Icon(Icons.school, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Text(
                                'Examination',
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
                    const SizedBox(height: 60),

                    // Status Message
                    Center(
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
                            Text(
                              isRejected && ctrl.remarks.value.isNotEmpty
                                  ? ctrl.remarks.value
                                  : statusMsg,
                              style: const TextStyle(
                                fontSize: 13,
                                color: _navy,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),

                    const Text('Progress...', style: TextStyle(color: _navy, fontSize: 17, fontWeight: FontWeight.bold)),
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
                  ],
                ),
              ),
            ),

           Padding(
  padding: const EdgeInsets.fromLTRB(49, 12, 49, 59),
  child: ElevatedButton(
    onPressed: isApproved ? () => Get.toNamed(AppRoutes.nameCorrection) : null,

    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(60),
      backgroundColor: isApproved ? _navy : Colors.grey.shade400, // ✅ Set color conditionally
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Text(
      'PROCEED NAME CORRECTION',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isApproved ? Colors.white : Colors.black38, // ✅ Text style depends on approval
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

// ---- Bottom Navigation ----
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
