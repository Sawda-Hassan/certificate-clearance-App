import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../controller/finance_controller.dart';
import '../../../routes/app_routes.dart';


const _navy = Color(0xFF0A2647);
const _green = Color(0xFF35C651);
const _lightBlue = Color(0xFFE8F3FF);
const _orange = Color(0xFFFF9800);

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
      ctrl.loadStatus(sid);
    } else {
      print('❌ No studentId in storage');
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

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CurvedAppBar(title: 'individual Clearance Status'),
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
                    const SizedBox(height: 48),

                    // Finance Status Card
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

                    const SizedBox(height: 24),

                    // 🔥 NEW PAYMENT WARNING CARD
    if (!isCleared)
  Padding(
    padding: const EdgeInsets.only(top: 4.0),
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 62),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3FF),
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
                radius: 14, // 🔽 smaller
                child: Icon(Icons.warning_amber_rounded, size: 18, color: Colors.orange.shade700),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'lacag baa laguu leeyahay ${unpaid.toStringAsFixed(3)}',
            style: const TextStyle(
              color: _navy,
              fontWeight: FontWeight.bold,
              fontSize: 11.5, // 🔽 smaller font
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          const Text(
            'would like to pay !',
            style: TextStyle(
              color: _navy,
              fontWeight: FontWeight.w600,
              fontSize: 10.5, // 🔽 smaller font
            ),
          ),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.financePayment),
          
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // 🔽 tighter
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('PAY', style: TextStyle(fontSize: 12)), // 🔽 smaller
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  ),



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
                onPressed: isCleared ? () => Get.offAllNamed('/exam') : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  backgroundColor: isCleared ? _navy : Colors.grey.shade400,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'PROCEED EXAM CLEARANCE',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: isCleared ? Colors.white : Colors.black38),
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
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 16, right: 16),
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
