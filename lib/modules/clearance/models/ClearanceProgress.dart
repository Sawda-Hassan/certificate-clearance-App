class GroupClearance {
  final String facultyStatus;
  final String libraryStatus;
  final String labStatus;

  GroupClearance({
    required this.facultyStatus,
    required this.libraryStatus,
    required this.labStatus,
  });

  factory GroupClearance.fromJson(Map<String, dynamic> json) {
    final progress = json['clearanceProgress'];
    return GroupClearance(
      facultyStatus: progress['faculty']['status'],
      libraryStatus: progress['library']['status'],
      labStatus: progress['lab']['status'],
    );
  }
}
