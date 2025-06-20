import 'package:get/get.dart';
import '../model/examination_model.dart';
import '../service/examination_service.dart';

class ExaminationController extends GetxController {
  var isLoading = true.obs;
  var status = ''.obs;
  var remarks = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExaminationStatus();
  }

  Future<void> fetchExaminationStatus() async {
    try {
      isLoading.value = true;
      print('📡 Fetching examination status...');

      final data = await ExaminationService.getExaminationStatus();

      if (data != null) {
        print('✅ Response received:');
        print('   ➤ canProceed: ${data.canProceed}');
        print('   ➤ failedCourses: ${data.failedCourses}');
        print('   ➤ message: ${data.message}');

        status.value = data.canProceed ? 'Approved' : 'Pending';
        remarks.value = data.message;
        print('✅ Final computed status: ${status.value}');
      } else {
        print('⚠️ No data returned from backend (null model)');
        status.value = 'Pending';
        remarks.value = '';
      }
    } catch (e) {
      print('❌ Exception during fetchExaminationStatus: $e');
      status.value = 'Pending';
      remarks.value = '';
    } finally {
      isLoading.value = false;
    }
  }
}
