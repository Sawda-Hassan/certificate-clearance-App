import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class EligibilityModel {
  final bool canProceed;
  final bool failedCourses;
  final bool showNameCorrectionOption;
  final String message;

  EligibilityModel({
    required this.canProceed,
    required this.failedCourses,
    required this.showNameCorrectionOption,
    required this.message,
  });

  factory EligibilityModel.fromJson(Map<String, dynamic> json) {
    return EligibilityModel(
      canProceed: json['canProceed'] ?? false,
      failedCourses: json['failedCourses'] ?? false,
      showNameCorrectionOption: json['showNameCorrectionOption'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class ExaminationService {
  static const baseUrl = 'http://10.0.2.2:5000/api/examination';

  static Future<EligibilityModel?> getExaminationStatus() async {
    final box = GetStorage();
    final studentId = box.read('studentId');

    if (studentId == null) {
      print('⚠️ No studentId in storage.');
      return null;
    }

    final url = Uri.parse('$baseUrl/cleared-students');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Find this student's record
        final student = data.firstWhere(
          (item) =>
              item['studentId'] != null &&
              item['studentId']['studentId'] == studentId,
          orElse: () => null,
        );

        final isCleared = student != null;
        bool showNameCorrectionPopup = false;

        if (isCleared) {
          final correctionStatus = student['studentId']['nameCorrectionRequested'];
          showNameCorrectionPopup =
              correctionStatus == null ||
              correctionStatus.toString().toLowerCase() == 'null';
        }

        return EligibilityModel(
          canProceed: isCleared,
          failedCourses: false,
          showNameCorrectionOption: showNameCorrectionPopup,
          message: isCleared
              ? '✅ You are cleared for certificate collection.'
              : '⏳ Your examination clearance is still pending.',
        );
      } else {
        print('❌ Failed to fetch clearance status: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exception in getExaminationStatus: $e');
      return null;
    }
  }
}
