class LeaveSummaryModel {
  final String leaveType;
  final double leavesAvailble;
  final double leavesAccrued;
  final double leavesTaken;

  LeaveSummaryModel(
      {required this.leaveType,
      required this.leavesAvailble,
      required this.leavesAccrued,
      required this.leavesTaken});

  factory LeaveSummaryModel.fromJson(Map<String, dynamic> json) {
    return new LeaveSummaryModel(
        leaveType: json['LeaveType'],
        leavesAvailble: json['LeavesAvailable'],
        leavesAccrued: json['LeavesAccrued'],
        leavesTaken: json['LeavesTaken']);
  }
}
