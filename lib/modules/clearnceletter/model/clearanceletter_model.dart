class ClearanceLetterModel {
  final Student student;
  final Appointment appointment;

  ClearanceLetterModel({required this.student, required this.appointment});

  factory ClearanceLetterModel.fromJson(Map<String, dynamic> json) {
    return ClearanceLetterModel(
      student: Student.fromJson(json['student']),
      appointment: Appointment.fromJson(json['appointment']),
    );
  }
}

class Student {
  final String name;
  final String studentId;
  final String faculty;
  final String program;

  Student({
    required this.name,
    required this.studentId,
    required this.faculty,
    required this.program,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        name: json['name'],
        studentId: json['studentId'],
        faculty: json['faculty'],
        program: json['program'],
      );
}

class Appointment {
  final String dateFormatted;
  final String timeRange;
  final String location;

  Appointment({
    required this.dateFormatted,
    required this.timeRange,
    required this.location,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        dateFormatted: json['dateFormatted'],
        timeRange: json['timeRange'],
        location: json['location'],
      );
}
