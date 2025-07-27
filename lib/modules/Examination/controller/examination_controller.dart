import 'package:get/get.dart';
import '../service/examination_service.dart';
import '../../../socket_service.dart'; // Make sure you have this

class ExaminationController extends GetxController {
  var isLoading = true.obs;
  var status = ''.obs;
  var remarks = ''.obs;
  var failedCourses = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchExaminationStatus();

    // ✅ Correct socket event name from backend
    SocketService().on('examStatusChanged', _handleExamStatusChanged);
    SocketService().on('course:updated', _handleCourseUpdate);
  }

  @override
  void onClose() {
    SocketService().off('examStatusChanged', _handleExamStatusChanged);
    SocketService().off('course:updated', _handleCourseUpdate);
    super.onClose();
  }

  // 🔁 Called when course record is updated in backend
  void _handleCourseUpdate(dynamic data) {
    final studentId = data?['studentId'];
    final message = data?['message'] ?? '';
    print('[SOCKET] 📚 Course Updated: $studentId → $message');

    fetchExaminationStatus(); // Re-check eligibility
  }

  // ✅ Called when exam approval/rejection is emitted via socket
  void _handleExamStatusChanged(dynamic data) {
    final studentId = data?['studentId'];
    final newStatus = data?['status'];
    final newRemarks = data?['remarks'] ?? '';

    print('[SOCKET] 🎓 Exam status update: $newStatus');

    // ✅ Use safe delayed update to avoid setState/build conflict
    Future.microtask(() {
      if (newStatus != null) {
        status.value = newStatus;
        remarks.value = newRemarks;
      }
    });
  }

  // 📥 Called on init or refresh
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
