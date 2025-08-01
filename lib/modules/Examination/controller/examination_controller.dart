
import 'package:get/get.dart';
import '../service/examination_service.dart';
import '../../../socket_service.dart';

class ExaminationController extends GetxController {
  var isLoading = true.obs;
  var status = ''.obs;
  var remarks = ''.obs;
  var failedCourses = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchExaminationStatus();

    final socket = Get.find<SocketService>().socket;

    socket.on('examStatusChanged', _handleExamStatusChanged);
    socket.on('course:updated', _handleCourseUpdate);
  }

  @override
  void onClose() {
    final socket = Get.find<SocketService>().socket;

    socket.off('examStatusChanged', _handleExamStatusChanged);
    socket.off('course:updated', _handleCourseUpdate);

    super.onClose();
  }

  // 🔁 Called when course record is updated in backend
  void _handleCourseUpdate(dynamic data) {
    final studentId = data?['studentId'];
    final message = data?['message'] ?? '';
    print('[SOCKET] 📚 Course Updated: $studentId → $message');

    fetchExaminationStatus(); // Refresh status from API
  }

  // ✅ Called when exam approval/rejection is emitted via socket
  void _handleExamStatusChanged(dynamic data) {
  final studentId = data?['studentId'];
  final newStatus = data?['status'];
  final newRemarks = data?['remarks'] ?? '';

  print('[SOCKET] 🎓 Exam status update: $newStatus');

  // ✅ Always re-fetch full data
  Future.microtask(() async {
    await fetchExaminationStatus(); // <-- revalidates status
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
