class StudentModel {
  final String id;                  // MongoDB _id or id
  final String studentId;          // e.g., C1210048
  final String fullName;
  final String motherName;
  final String gender;
  final String phone;
  final String email;
  final String studentClass;
  final int yearOfAdmission;
  final int yearOfGraduation;
  final int duration;
  final String mode;
  final String status;
  final String profilePicture;
  final String? groupId;           // ✅ Added groupId field

  StudentModel({
    required this.id,
    required this.studentId,
    required this.fullName,
    required this.motherName,
    required this.gender,
    required this.phone,
    required this.email,
    required this.studentClass,
    required this.yearOfAdmission,
    required this.yearOfGraduation,
    required this.duration,
    required this.mode,
    required this.status,
    required this.profilePicture,
    this.groupId,                  // ✅ Include in constructor (optional)
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? json['_id'] ?? '',
      studentId: json['studentId'] ?? '',
      fullName: json['fullName'] ?? '',
      motherName: json['motherName'] ?? '',
      gender: json['gender'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      studentClass: json['studentClass'] ?? '',
      yearOfAdmission: json['yearOfAdmission'] ?? 0,
      yearOfGraduation: json['yearOfGraduation'] ?? 0,
      duration: json['duration'] ?? 0,
      mode: json['mode'] ?? '',
      status: json['status'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      groupId: json['groupId'], // ✅ Read from JSON if exists
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'fullName': fullName,
      'motherName': motherName,
      'gender': gender,
      'phone': phone,
      'email': email,
      'studentClass': studentClass,
      'yearOfAdmission': yearOfAdmission,
      'yearOfGraduation': yearOfGraduation,
      'duration': duration,
      'mode': mode,
      'status': status,
      'profilePicture': profilePicture,
      'groupId': groupId, // ✅ Include in serialization
    };
  }
}
