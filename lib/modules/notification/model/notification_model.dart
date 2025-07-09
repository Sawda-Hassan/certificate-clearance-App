/*class AppNotification {
  final String id;
  final String studentId;
  final String message;
  final String type;
  final bool isRead;
  final String createdAt;

  AppNotification({
    required this.id,
    required this.studentId,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['_id'],
      studentId: json['studentId'],
      message: json['message'],
      type: json['type'],
      isRead: json['isRead'],
      createdAt: json['createdAt'],
    );
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      studentId: studentId,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
*/