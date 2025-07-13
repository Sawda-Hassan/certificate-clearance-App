import 'package:get/get.dart';
import '../model/clearance_step.dart';
import '../service/clearance_service.dart';

class ClearanceController extends GetxController {
  var steps = <ClearanceStep>[].obs;
  var isLoading = true.obs;

  Future<void> loadClearance(String studentId) async {
    try {
      isLoading.value = true;
      final result = await ClearanceService.getClearanceSteps(studentId);
      steps.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Unable to load clearance steps');
    } finally {
      isLoading.value = false;
    }
  }
}
