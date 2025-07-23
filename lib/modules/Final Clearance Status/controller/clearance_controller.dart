import 'package:get/get.dart';
import '../model/clearance_step.dart';
import '../service/clearance_service.dart';

class ClearanceController extends GetxController {
  var steps = <ClearanceStep>[].obs;
  var isLoading = true.obs;

  // Method to load the clearance steps for the student
  Future<void> loadClearance(String studentId) async {
    try {
      isLoading.value = true;
      print('🔄 Loading clearance for: $studentId');
      final result = await ClearanceService.getClearanceSteps(studentId);
      steps.assignAll(result);
      print('✅ Loaded ${result.length} steps');
    } catch (e) {
      print('❌ Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to check name correction status for the student
  Future<String> checkNameCorrectionStatus(String studentId) async {
    try {
      final response = await ClearanceService.getNameCorrectionStatus(studentId);
      return response.status; // Should return 'approved', 'pending', 'rejected'
    } catch (e) {
      print('❌ Error checking name correction status: $e');
      return 'pending'; // Default to 'pending' if there's an error
    }
  }
}
