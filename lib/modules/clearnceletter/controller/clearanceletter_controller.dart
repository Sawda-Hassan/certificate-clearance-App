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
      //print('❌ No student logged in!');
      Get.snackbar("Error", "Student not logged in.");
      isLoading.value = false;
      return;
    }

    try {
      //print('🔄 Fetching clearance letter for studentId: $studentId');

      final data = await ClearanceLetterService.fetchClearanceLetter(studentId);

     // print('✅ Fetched student: ${data.student.name}');
      //print('📅 Appointment: ${data.appointment.dateFormatted}');
      //print('🕒 Time: ${data.appointment.timeRange}');
      //print('📍 Location: ${data.appointment.location}');

      _clearanceData.value = data;
    } catch (e, stack) {
      //print('❌ ERROR fetching clearance letter: $e');
      //print('📄 STACK TRACE:\n$stack');
      Get.snackbar("Error", "Failed to fetch clearance letter data");
    } finally {
      isLoading.value = false;
    }
  }
}
