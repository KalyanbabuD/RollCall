class AttendanceModel {
  final DateTime? dateOfTransaction;
  final String? inTime;
  final String outTime;
  final String duration;
  final String status;

  AttendanceModel(
      {required this.dateOfTransaction,
      required this.inTime,
      required this.outTime,
      required this.duration,
      required this.status});

//final items = (data['items'] as List).map((i) => new CardInfo.fromJson(i));
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return new AttendanceModel(
        dateOfTransaction: DateTime.parse(json['DateOfTransaction']),
        inTime: json['InTime'],
        outTime: json['OutTime'],
        duration: json['Duration'],
        status: json['InStatus']);
  }
}
