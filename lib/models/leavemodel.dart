class LeaveModel {
  final int superId;
  final int regId;
  final int leaveTypeId;
  final DateTime startDate;
  final DateTime endDate;
  final String updatedBy;
  final String comments;

  LeaveModel(
      {required this.superId,
      required this.regId,
      required this.leaveTypeId,
      required this.startDate,
      required this.endDate,
      required this.updatedBy,
      required this.comments});

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
        superId: json['SuperId'],
        regId: json['RegId'],
        leaveTypeId: json['Reason'],
        startDate: json['StartDate'],
        endDate: json['EndDate'],
        updatedBy: json['UpdatedBy'],
        comments: json['Comments']);
  }
}
