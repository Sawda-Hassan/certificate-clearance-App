import 'package:get/get.dart';
import '../model/clearance_step.dart';
import '../service/clearance_service.dart';

import 'package:get/get.dart';
import '../model/clearance_step.dart';
import '../service/clearance_service.dart';

class ClearanceController extends GetxController {
  var steps = <ClearanceStep>[].obs;
  var isLoading = true.obs;

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
}

