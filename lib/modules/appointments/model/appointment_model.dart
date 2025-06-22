class AppointmentModel {
  final String id;
  final String studentId;
  final DateTime appointmentDate;
  final bool rescheduled;
  final String? rescheduleReason;
  final bool checkedIn;
  final String status;
  final DateTime? attendedAt;

  AppointmentModel({
    required this.id,
    required this.studentId,
    required this.appointmentDate,
    required this.status,
    this.rescheduled = false,
    this.rescheduleReason,
    this.checkedIn = false,
    this.attendedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'],
      studentId: json['studentId'] is String ? json['studentId'] : json['studentId']['_id'],
      appointmentDate: DateTime.parse(json['appointmentDate']),
      rescheduled: json['rescheduled'] ?? false,
      rescheduleReason: json['rescheduleReason'],
      checkedIn: json['checkedIn'] ?? false,
      attendedAt: json['attendedAt'] != null ? DateTime.parse(json['attendedAt']) : null,
      status: json['status'] ?? 'pending',
    );
  }
}
