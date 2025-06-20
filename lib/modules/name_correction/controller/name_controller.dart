import 'package:get/get.dart';
import '../model/name_model.dart';
import '../service/name_service.dart';
import 'package:get_storage/get_storage.dart';

class NameController extends GetxController {
  var isLoading = true.obs;
  var student = Rxn<StudentModel>();
  var correctionRequested = RxnBool(); // ✅ FIXED: now you can access correctionRequested.value

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration.zero, fetchStudentProfile);
  }

  Future<void> fetchStudentProfile() async {
  isLoading.value = true;

  final id = box.read('id');
  print('📦 Fetched from GetStorage: id = $id'); // ✅ Debug print added

  if (id == null || id is! String || id.isEmpty) {
    print('❌ No valid student ID found in GetStorage');
    Get.snackbar('Error', 'Student ID not found. Please log in again.');
    isLoading.value = false;
    return;
  }

  try {
    final result = await NameService.getStudentById(id).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Request timed out'),
    );

    if (result != null) {
      print('✅ Student profile loaded: ${result.fullName}');
      student.value = result;
    } else {
      print('⚠️ Student result was null');
      Get.snackbar('Error', 'Failed to load student profile');
    }
  } catch (e) {
    print('❌ Exception in fetchStudentProfile: $e');
    Get.snackbar('Error', 'Something went wrong');
  } finally {
    isLoading.value = false;
  }
}

  Future<void> setCorrectionRequested(bool requested) async {
    final studentId = student.value?.id ?? '';
    if (studentId.isEmpty) {
      Get.snackbar("Error", "Student ID is missing");
      return;
    }

    final success = await NameService.toggleNameCorrection(studentId, requested);
    if (success) {
      correctionRequested.value = requested; // ✅ Track selection state
      if (requested) {
        Get.toNamed('/name-correction-form');
      }
    } else {
      Get.snackbar("Error", "Failed to update name correction status");
    }
  }

  Future<void> requestCertificate() async {
    Get.snackbar("Request sent", "Your certificate request has been submitted");
  }
}
