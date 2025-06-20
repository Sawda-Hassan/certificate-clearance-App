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
