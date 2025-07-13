import 'package:get/get.dart';
import '../model/name_model.dart';
import '../service/name_service.dart';
import 'package:get_storage/get_storage.dart';

class NameController extends GetxController {
  var isLoading = true.obs;
  var student = Rxn<StudentModel>();
  var correctionRequested = RxnBool();

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, fetchStudentProfile);
  }

  Future<void> fetchStudentProfile() async {
    isLoading.value = true;

    final id = box.read('id');
    print('🧠 [Storage] Retrieved ID from GetStorage: $id');

    if (id == null || id is! String || id.isEmpty) {
      Get.snackbar('Error', 'Student ID not found. Please log in again.');
      isLoading.value = false;
      return;
    }

    try {
      final result = await NameService.getStudentById(id).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('⏱ Request timed out'),
      );

      if (result != null) {
        print('✅ [Profile] Loaded: ${result.fullName}');
        student.value = result;
      } else {
        Get.snackbar('Error', 'Failed to load student profile');
        print('⚠️ [Profile] API returned null');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      print('❌ [Profile] Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setCorrectionRequested(bool requested) async {
    final studentId = student.value?.studentId ?? ''; // ✅ MUST BE studentId like "C1210159"

    print('🎯 [setCorrectionRequested] studentId = $studentId');

    if (studentId.isEmpty) {
      Get.snackbar("Error", "Student ID is missing");
      print("❌ [Toggle] Missing student ID.");
      return;
    }

    final success = await NameService.toggleNameCorrection(studentId, requested);
    if (success) {
      correctionRequested.value = requested;
      print('✅ [Toggle] Request success. New state: $requested');
      if (requested) {
        Get.toNamed('/name-correction-form');
      }
    } else {
      print('❌ [Toggle] Failed to update correction status.');
      Get.snackbar("Error", "Failed to update name correction status");
    }
  }

  Future<void> requestCertificate() async {
    Get.snackbar("Request sent", "Your certificate request has been submitted");
  }
}
