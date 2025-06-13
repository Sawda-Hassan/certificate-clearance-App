class FinanceModel {
  final String status;
  final String remarks;
  final double unpaidAmount;

  FinanceModel({
    required this.status,
    required this.remarks,
    required this.unpaidAmount,
  });

  factory FinanceModel.fromJson(Map<String, dynamic> json) {
    return FinanceModel(
      status: json['status'] ?? '',
      remarks: json['remarks'] ?? '',
      unpaidAmount: (json['unpaidAmount'] ?? 0).toDouble(),
    );
  }
}
