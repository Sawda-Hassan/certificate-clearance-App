import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../model/nameupload_model.dart';
import '../service/nameupload_service.dart';

class NameUploadController extends GetxController {
  final RxString requestedName = ''.obs;
  final RxString selectedFileName = ''.obs;
  final Rx<Uint8List?> selectedFileBytes = Rx<Uint8List?>(null);
  final RxBool isConfirmed = false.obs;
  final RxBool isLoading = false.obs;

  final NameUploadService _service = NameUploadService();

  bool get isFormValid =>
      requestedName.value.isNotEmpty &&
      selectedFileBytes.value != null &&
      isConfirmed.value;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
      withData: true, // ✅ needed for Uint8List
    );

    if (result != null && result.files.single.bytes != null) {
      selectedFileBytes.value = result.files.single.bytes!;
      selectedFileName.value = result.files.single.name;
    } else {
      Get.snackbar("Error", "File not selected or unsupported");
    }
  }

  Future<void> submit(String studentId) async {
    if (!isFormValid) {
      Get.snackbar('Missing', 'Please complete all fields.');
      return;
    }

    isLoading.value = true;

    final model = NameUploadModel(
      studentId: studentId,
      requestedName: requestedName.value,
      documentName: selectedFileName.value,
      fileBytes: selectedFileBytes.value!,
    );

    final success = await _service.upload(model);
    isLoading.value = false;

    if (success) {
      Get.snackbar('Success', 'Document uploaded');
      Get.back();
    } else {
      Get.snackbar('Error', 'Upload failed');
    }
  }
}
