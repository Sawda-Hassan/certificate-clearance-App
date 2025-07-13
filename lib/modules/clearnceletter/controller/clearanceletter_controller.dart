import 'package:get/get.dart';
import '../model/clearanceletter_model.dart';
import '../service/clearanceletter_service.dart';
import '../../../modules/auth/controllers/auth_controller.dart';

class ClearanceLetterController extends GetxController {
  final _clearanceData = Rxn<ClearanceLetterModel>();
  final isLoading = false.obs;

  ClearanceLetterModel? get clearanceData => _clearanceData.value;

  final auth = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchClearanceLetterData();
  }

  Future<void> fetchClearanceLetterData() async {
    isLoading.value = true;

    final studentId = auth.loggedInStudent.value?.studentId;

    if (studentId == null) {
      print('❌ [ClearanceController] No student ID found.');
      Get.snackbar("Error", "Student not logged in.");
      isLoading.value = false;
      return;
    }

    try {
      print('🌐 [ClearanceController] Fetching clearance letter for: $studentId');

      final data = await ClearanceLetterService.fetchClearanceLetter(studentId);

      print('✅ [ClearanceController] Clearance letter fetched:');
      print('👤 Student: ${data.student.name}, ${data.student.studentId}');
      print('📅 Appointment: ${data.appointment.dateFormatted}');
      print('🕒 Time: ${data.appointment.timeRange}');
      print('📍 Location: ${data.appointment.location}');

      _clearanceData.value = data;
    } catch (e, stack) {
      print('❌ [ClearanceController] Error: $e');
      print('📄 Stack Trace:\n$stack');
      Get.snackbar("Error", "Failed to fetch clearance letter data");
    } finally {
      isLoading.value = false;
    }
  }
}
