class GroupClearanceStatus {
  final bool groupPhaseCleared;
  final Map<String, String> departments;

  GroupClearanceStatus({
    required this.groupPhaseCleared,
    required this.departments,
  });

  factory GroupClearanceStatus.fromJson(Map<String, dynamic> json) {
    return GroupClearanceStatus(
      groupPhaseCleared: json['groupPhaseCleared'],
      departments: Map<String, String>.from(json['departments']),
    );
  }
}
