class LibraryModel {
  final String status;
  final String remarks;
  final String? groupId;

  LibraryModel({
    required this.status,
    required this.remarks,
    this.groupId,
  });

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
      groupId: json['groupId']?.toString(),
    );
  }
}
