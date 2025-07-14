import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─── Screens ─────────────────────────────────────────────────────
import '../../FacultyClearancepage/FacultyClearancePage.dart';
import '../../Final Clearance Status/veiw/final_clearance_status.dart';
import '../../Final Clearance Status/controller/clearance_controller.dart';

// ─── Controllers ────────────────────────────────────────────────
import '../../FacultyClearancepage/controlerr/faculty_controller.dart';
import '../../auth/controllers/auth_controller.dart';


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
    final FacultyController facultyCtrl = Get.put(FacultyController());
    final ClearanceController clearanceCtrl = Get.put(ClearanceController());

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
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/g.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
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
                              facultyCtrl.isLoading.value = true;

                              final studentId = Get.find<AuthController>()
                                  .loggedInStudent
                                  .value
                                  ?.studentId;

                              print('🧠 Logged in studentId: $studentId');

                              if (studentId != null) {
                                await clearanceCtrl.loadClearance(studentId);

                                print('📦 Clearance Steps Length: ${clearanceCtrl.steps.length}');

                                for (var step in clearanceCtrl.steps) {
                                  print('🔍 Step: ${step.title} - Status: ${step.status}');
                                }

                                if (clearanceCtrl.steps.isEmpty) {
                                  print('🚫 No clearance steps found. Starting clearance...');
                                  await facultyCtrl.startClearance();
                                  Get.to(() => FacultyClearancePage());
                                } else {
                                  final allowedStatuses = ['cleared', 'approved'];

                                  final allCleared = clearanceCtrl.steps.every(
                                    (s) => allowedStatuses.contains(s.status.toLowerCase()),
                                  );

                                  print('✅ All Steps Cleared: $allCleared');

                                  if (allCleared) {
                                    print('🎉 Navigating to FinalClearanceStatus()');
                                    Get.to(() => FinalClearanceStatus());
                                  } else {
                                    print('➡️ Some steps still pending. Navigating to FacultyClearancePage()');
                                    Get.to(() => FacultyClearancePage());
                                  }
                                }
                              } else {
                                print('❌ studentId is NULL. Cannot proceed.');
                              }

                              facultyCtrl.isLoading.value = false;
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