import 'package:get/get.dart';
 import 'package:get/get.dart';
import '../model/faculty_models.dart';   // ✅ keep once
import '../service/faculty_service.dart';
import '../FacultyClearancePage.dart';  // or correct relative path

    
// lib/FacultyClearancepage/controller/faculty_controller.dart
import '../model/faculty_models.dart';
import '../service/faculty_service.dart';
import '../FacultyClearancePage.dart';

class FacultyController extends GetxController {
  final _svc = FacultyService();

  final isLoading = false.obs;
  final steps     = <ClearanceStep>[].obs;

  int    get approvedCount => steps.where((s) => s.state == StepState.approved).length;
  double get percent       => steps.isEmpty ? 0 : approvedCount / steps.length;
  bool   get allApproved   => percent == 1.0;

  @override
  void onInit() {
    super.onInit();
    loadStatus();
  }

  /* Load timeline for current student */
  Future<void> loadStatus() async {
    isLoading.value = true;
    steps.assignAll(await _svc.fetchStudentSteps());
    isLoading.value = false;
  }

  /* Handle “Start Faculty Clearance” tap */
  Future<void> startClearance() async {
    isLoading.value = true;

    try {
      final res  = await _svc.startClearance();
      final int  code = res['code'] ?? 0;
      final data = res['data'];

      if (code == 201) {
        Get.snackbar('Success', 'Clearance request sent.');
        await loadStatus();                                  // show pending
      } else if (code == 400 &&
          (data?['message'] ?? '').contains('already')) {
        // Someone else already created the request
        Get.snackbar('Info', 'Clearance already started for this group');

        // use the data blob directly (it’s the group record)
        if (data is Map<String, dynamic>) {
          steps.assignAll(_svc.mapDocToSteps(data));
        } else {
          await loadStatus(); // fallback
        }
      } else {
        Get.snackbar('Error', data?['message'] ?? 'Unexpected server error');
      }

      // Navigate to status page so CTA disappears
      Get.offAll(() => FacultyClearancePage());
    } catch (e) {
      Get.snackbar('Network error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
