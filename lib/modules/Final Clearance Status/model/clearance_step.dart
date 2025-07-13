class ClearanceStep {
  final String title;
  final String status;
  final DateTime? clearedOn;

  ClearanceStep({
    required this.title,
    required this.status,
    required this.clearedOn,
  });

  factory ClearanceStep.fromJson(Map<String, dynamic> json) {
    return ClearanceStep(
      title: json['title'],
      status: json['status'],
      clearedOn: json['clearedOn'] != null ? DateTime.parse(json['clearedOn']) : null,
    );
  }
}
