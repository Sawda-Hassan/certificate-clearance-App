import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Screens
import '../../FacultyClearancepage/FacultyClearancePage.dart';
import '../../../modules/Groupclearance/veiw/group_clearance_status_view.dart';
import '../../../modules/Final Clearance Status/veiw/final_clearance_status.dart';

// Controllers
import '../../../modules/Groupclearance/controller/group_clearance_controller.dart';
import '../../../modules/Final Clearance Status/controller/clearance_controller.dart';
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

            // Image
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

            // Action Button
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
                              final studentId = Get.find<AuthController>()
                                  .loggedInStudent
                                  .value!
                                  .studentId;

                              await facultyCtrl.startClearance();
                              bool navigated = false;

                              // 1️⃣ Check Final Clearance + Name Correction Status
                              try {
                                final finalCtrl = Get.put(ClearanceController());
                                await finalCtrl.loadClearance(studentId);

                                final approvedSteps = finalCtrl.steps
                                    .where((s) => s.status.toLowerCase() == 'approved')
                                    .length;

                                final nameCorrectionStatus = await finalCtrl.checkNameCorrectionStatus(studentId);

                                final allCleared = approvedSteps == 5;
                                final hasSelectedNameCorrection =
                                    nameCorrectionStatus != null &&
                                    nameCorrectionStatus != 'null' &&
                                    nameCorrectionStatus.isNotEmpty;

                                if (allCleared && hasSelectedNameCorrection) {
                                  Get.to(() => const FinalClearanceStatus());
                                  navigated = true;
                                }
                              } catch (e) {
                                print('⚠️ Final clearance or name correction check failed: $e');
                              }

                              if (navigated) return;

                              // 2️⃣ Check Group Clearance
                              try {
                                final groupCtrl = Get.put(GroupClearanceController());
                                await groupCtrl.loadClearanceStatus(studentId);
                                final groupCleared =
                                    groupCtrl.clearanceStatus.value?.groupPhaseCleared ?? false;

                                if (groupCleared) {
                                  Get.to(() => const GroupClearanceStatusPage());
                                  navigated = true;
                                }
                              } catch (e) {
                                print('⚠️ Group clearance not available: $e');
                              }

                              if (!navigated) {
                                // 3️⃣ Fallback to Faculty Clearance
                                Get.to(() => const FacultyClearancePage());
                              }
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
