// lib/YourModule/student_welcome_screen.dart
// --------------------------------------------------
// Navigates to the FacultyClearancePage to show the group’s clearance status.
// --------------------------------------------------

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Your screens ──────────────────────────────────────────────────────────
// Adjust the path below if necessary (matching your folder structure):
import '../../FacultyClearancepage/FacultyClearancePage.dart';

// ─── Controllers ───────────────────────────────────────────────────────────
import '../../FacultyClearancepage/controlerr/faculty_controller.dart';

class StudentWelcomeScreen extends StatelessWidget {
  final String studentName;
  final String gender;

  const StudentWelcomeScreen({
    Key? key,
    required this.studentName,
    required this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instantiate (or find) the FacultyController once for this flow.
    final FacultyController facultyCtrl = Get.put(FacultyController());

    final String profileImage = gender.toLowerCase() == 'female'
        ? 'assets/images/girl_profile.png'
        : 'assets/images/boy_profile.png';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 36),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: const Color.fromARGB(255, 255, 202, 27),
              backgroundImage: AssetImage(profileImage),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Hello ${studentName.split(" ").first}!',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Start Your Certificate Clearance \nJourney Here 🖐️',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // ── illustration ──
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/g.png',
                  width: 300, // scale down if 1050 is too big
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // ── action button ──
            Padding(
              padding: const EdgeInsets.only(bottom: 89),
              child: Center(
                child: Obx(
                  () => SizedBox(
                    width: 270,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: facultyCtrl.isLoading.value
                          ? null
                          : () async {
                              // 1) Call startClearance() to ensure the group record exists
                              await facultyCtrl.startClearance();

                              // 2) Navigate to the FacultyClearancePage to read status
                              Get.to(() => FacultyClearancePage());
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A2647),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: facultyCtrl.isLoading.value
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            )
                          : const Text(
                              'START CERTIFICATE CLEARANCE',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.6,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
