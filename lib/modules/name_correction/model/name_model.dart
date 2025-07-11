class StudentModel {
  String? id;
  String? studentId;
  String? fullName;

  StudentModel({this.id, this.studentId, this.fullName});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['_id'],
      studentId: json['studentId'],
      fullName: json['fullName'],
    );
  }
}
