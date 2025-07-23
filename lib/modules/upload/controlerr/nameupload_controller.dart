import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class NameUploadController extends GetxController {
  final RxString requestedName = ''.obs;
  final RxString selectedFileName = ''.obs;
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxBool isConfirmed = false.obs;
  final RxBool isLoading = false.obs;
  final RxString currentName = ''.obs; // ✅ Add this

  bool get isFormValid =>
      requestedName.value.isNotEmpty &&
      selectedFile.value != null &&
      isConfirmed.value;

  /// Pick PDF, JPG, or PNG file
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      selectedFile.value = File(result.files.single.path!);
      selectedFileName.value = result.files.single.name;
    } else {
      Get.snackbar("Error", "File not selected or unsupported");
    }
  }

  /// Upload to server
  Future<void> submit(String studentId) async {
    if (!isFormValid) {
      Get.snackbar('Missing', 'Please complete all fields.');
      return;
    }

    isLoading.value = true;

    final uri = Uri.parse("http://10.0.2.2:5000/api/students/upload-correction-doc");
    final filePath = selectedFile.value!.path;
    final fileExt = filePath.split('.').last.toLowerCase();

    // Set the appropriate MIME type
    MediaType getMimeType(String ext) {
      switch (ext) {
        case 'pdf':
          return MediaType('application', 'pdf');
        case 'jpg':
        case 'jpeg':
          return MediaType('image', 'jpeg');
        case 'png':
          return MediaType('image', 'png');
        default:
          return MediaType('application', 'octet-stream');
      }
    }

    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['studentId'] = studentId
        ..fields['requestedName'] = requestedName.value
        ..files.add(await http.MultipartFile.fromPath(
          'document',
          filePath,
          filename: basename(filePath),
          contentType: getMimeType(fileExt),
        ));

      print("📤 Uploading...");
      print("👤 studentId: $studentId");
      print("✍️ requestedName: ${requestedName.value}");
      print("📎 file: $filePath");
      print("📄 MIME type: ${getMimeType(fileExt)}");

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print("✅ Success: ${responseBody.body}");
        Get.snackbar('Success', 'Document uploaded');
        Get.back();
      } else {
        print("❌ Failed: ${response.statusCode}");
        print("💥 Body: ${responseBody.body}");
        Get.snackbar('Error', 'Upload failed: ${responseBody.body}');
      }
    } catch (e) {
      print("🚨 Exception: $e");
      Get.snackbar('Error', 'Upload error occurred');
    } finally {
      isLoading.value = false;
    }
  }
}
