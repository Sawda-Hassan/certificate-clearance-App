
import 'package:flutter/material.dart' hide StepState; // hide StepState clash
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

// project imports ­────────────────────────────────────────────────────────────
import '../FacultyClearancepage/controlerr/faculty_controller.dart';
import '../FacultyClearancepage/model/faculty_models.dart';

const _navy = Color(0xFF0A2647);

// ---------------------------------------------------------------------------
// MAIN PAGE – reactive via Obx (GetX)
// ---------------------------------------------------------------------------
class FacultyClearancePage extends StatelessWidget {
  FacultyClearancePage({super.key});

  // shared controller instance (tag keeps it unique)
  final FacultyController ctrl =
      Get.isRegistered<FacultyController>(tag: 'faculty')
          ? Get.find<FacultyController>(tag: 'faculty')
          : Get.put(FacultyController(), tag: 'faculty');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1️⃣ loading spinner
      if (ctrl.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // 2️⃣ first‑time state – show CTA
      if (ctrl.steps.isEmpty) {
        return Scaffold(
          appBar: AppBar(title: const Text('Group Clearance status')),
          bottomNavigationBar: const _BottomNav(),
          body: Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Faculty Clearance'),
              onPressed: () => ctrl.startClearance(),
            ),
          ),
        );
      }

      // 3️⃣ normal progress view
      return Scaffold(
        backgroundColor: const Color(0xFFF1F3F8),
        appBar: const CurvedAppBar(
          title: 'Group Clearance status',
          leading: BackButton(color: Colors.white),
        ),
        bottomNavigationBar: const _BottomNav(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: _WhiteCard(
              steps: ctrl.steps,
              pct: ctrl.percent,
              done: ctrl.approvedCount,
              buttonEnabled: ctrl.allApproved,
            ),
          ),
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// BOTTOM NAVIGATION BAR
// ---------------------------------------------------------------------------
class _BottomNav extends StatelessWidget {
  const _BottomNav();
  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: _navy,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      );
}

// ---------------------------------------------------------------------------
// CUSTOM CURVED APP BAR
// ---------------------------------------------------------------------------
class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  const CurvedAppBar({super.key, required this.title, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(130);

  @override
  Widget build(BuildContext context) => ClipPath(
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
              left: 8,
              right: 8,
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (leading != null)
                  Align(alignment: Alignment.topLeft, child: leading!),
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

// ---------------------------------------------------------------------------
// WHITE CARD – timeline, gauge, CTA button
// ---------------------------------------------------------------------------
class _WhiteCard extends StatelessWidget {
  final List<ClearanceStep> steps;
  final double pct; // 0.0 – 1.0
  final int done;
  final bool buttonEnabled;
  const _WhiteCard({
    required this.steps,
    required this.pct,
    required this.done,
    required this.buttonEnabled,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Faculty Clearance status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            // timeline list
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: steps.length,
                itemBuilder: (_, i) => _StepTile(
                  step: steps[i],
                  isLast: i == steps.length - 1,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // bar + circular gauge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 60),
                  child: LinearPercentIndicator(
                    lineHeight: 10,
                    percent: pct.clamp(0.0, 1.0),
                    animation: true,
                    barRadius: const Radius.circular(50),
                    progressColor: pct == 0 ? Colors.grey : const Color(0xFF0E9E53),
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: -2,
                  child: Text(
                    '$done\n${steps.length}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: -32,
                  child: CircularPercentIndicator(
                    radius: 24,
                    lineWidth: 6,
                    percent: pct.clamp(0.0, 1.0),
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: pct == 0 ? Colors.grey : const Color(0xFF0E9E53),
                    backgroundColor: Colors.grey.shade300,
                    center: Text(
                      '${(pct * 100).round()}%',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),

            // CTA button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: buttonEnabled ? () => Get.offAllNamed('/library') : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navy,
                  disabledBackgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'PROCEED library clearance',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      );
}

// ---------------------------------------------------------------------------
// STEP TILE – pending | approved | rejected
// ---------------------------------------------------------------------------
class _StepTile extends StatelessWidget {
  final ClearanceStep step;
  final bool isLast;
  const _StepTile({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final approved = step.state == StepState.approved;
    final rejected = step.state == StepState.rejected;

    final borderColor = rejected ? Colors.red : _navy;
    final fillColor = approved ? _navy : Colors.white;
    final Icon? icon = approved
        ? const Icon(Icons.check, size: 14, color: Colors.white)
        : rejected
            ? const Icon(Icons.close, size: 14, color: Colors.red)
            : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fillColor,
                border: Border.all(color: borderColor, width: 2),
              ),
              alignment: Alignment.center,
              child: icon,
            ),
            if (!isLast) Container(width: 2, height: 48, color: borderColor),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              step.label,
              style: const TextStyle(fontSize: 14, height: 1.45, color: _navy),
            ),
          ),
        ),
      ],
    );
  }
}