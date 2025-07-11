class GroupClearanceStatus {
  final String? facultyStatus;
  final String? facultyReason;
  final String? libraryStatus;
  final String? labStatus;
  final StartedBy? startedBy;

  GroupClearanceStatus({
    this.facultyStatus,
    this.facultyReason,
    this.libraryStatus,
    this.labStatus,
    this.startedBy,
  });

  factory GroupClearanceStatus.fromJson(Map<String, dynamic> json) {
    return GroupClearanceStatus(
      facultyStatus: json['facultyStatus'],
      facultyReason: json['facultyReason'],
      libraryStatus: json['libraryStatus'],
      labStatus: json['labStatus'],
      startedBy: json['startedBy'] != null ? StartedBy.fromJson(json['startedBy']) : null,
    );
  }
}

class StartedBy {
  final String? id;
  final String? fullName;
  final String? studentId;

  StartedBy({this.id, this.fullName, this.studentId});

  factory StartedBy.fromJson(Map<String, dynamic> json) {
    return StartedBy(
      id: json['_id'],
      fullName: json['fullName'],
      studentId: json['studentId'],
    );
  }
}
