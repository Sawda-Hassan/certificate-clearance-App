import 'package:get/get.dart';
import '../service/examination_service.dart';

class ExaminationController extends GetxController {
  var isLoading = true.obs;
  var status = ''.obs;
  var remarks = ''.obs;
  var failedCourses = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchExaminationStatus();
  }

  Future<void> fetchExaminationStatus() async {
    try {
      isLoading.value = true;
      final data = await ExaminationService.getExaminationStatus();

      if (data != null) {
        print('🎯 data.canProceed: ${data.canProceed}');
        print('🎯 data.failedCourses: ${data.failedCourses}');
        print('🎯 data.message: ${data.message}');

        failedCourses.value = data.failedCourses;
        print('📋 Controller received failedCourses: ${failedCourses.value}');

        if (failedCourses.isNotEmpty) {
          status.value = 'Rejected';
          remarks.value =
              'You are not eligible for certificate collection. You failed ${failedCourses.join(", ")}.';
        } else {
          status.value = data.canProceed ? 'Approved' : 'Pending';
          remarks.value = data.message ?? '';
        }
      } else {
        print('⚠️ No data received from service.');
        status.value = 'Pending';
        remarks.value = '';
        failedCourses.clear();
      }
    } catch (e) {
      print('❌ Exception in ExaminationController: $e');
      status.value = 'Pending';
      remarks.value = '';
      failedCourses.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
