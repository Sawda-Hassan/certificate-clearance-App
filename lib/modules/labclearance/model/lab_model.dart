class LabModel {
  final String status;
  final String issues;
  final List<String> expectedItems;
  final List<String> returnedItems;
  final String? groupId;

  LabModel({
    required this.status,
    required this.issues,
    required this.expectedItems,
    required this.returnedItems,
    this.groupId,
  });

  factory LabModel.fromJson(Map<String, dynamic> json) {
    return LabModel(
      status: json['status'] ?? '',
      issues: json['issues'] ?? '',
      expectedItems: List<String>.from(json['expectedItems'] ?? []),
      returnedItems: List<String>.from(json['returnedItems'] ?? []),
      groupId: json['groupId']?.toString(),
    );
  }
}
