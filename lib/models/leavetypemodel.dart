class LeaveTypeModel {
  final int id;
  final String leaveType;

  LeaveTypeModel({required this.id, required this.leaveType});

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
        id: json['LeaveTypeId'], leaveType: json['LeaveTypeName']);
  }
}
