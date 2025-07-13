class EligibilityModel {
  final bool canProceed;
  final List<String> failedCourses;
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
      failedCourses: List<String>.from(json['failedCourses'] ?? []),
      showNameCorrectionOption: json['showNameCorrectionOption'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
