
class StudentModel {
  final String id;           // MongoDB _id
  final String studentId;    // Public student ID (e.g., C1210048)
  final String fullName;
  final String gender;

  StudentModel({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.gender,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
  return StudentModel(
    id: json['id'] ?? '',              // ✅ FIXED to match backend response
    studentId: json['studentId'] ?? '',
    fullName: json['fullName'] ?? '',
    gender: json['gender'] ?? '',
  );
}
}