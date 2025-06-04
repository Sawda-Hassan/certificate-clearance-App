class StudentModel {
  final String fullName;
  final String studentId;
  final String gender;

  StudentModel({
    required this.fullName,
    required this.studentId,
    required this.gender,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      fullName: json['fullName'],
      studentId: json['studentId'],
      gender: json['gender'],
    );
  }
}
