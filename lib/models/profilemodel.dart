class ProfileModel {
  final String name;
  final String empId;
  final String mobile;
  final String fatherName;
  final String qualification;
  final String emailId;
  final String address;
  final String aadhar;
  final String pan;
  final String uan;

  ProfileModel(
      {required this.name,
      required this.empId,
      required this.mobile,
      required this.fatherName,
      required this.qualification,
      required this.emailId,
      required this.address,
      required this.aadhar,
      required this.pan,
      required this.uan});

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return new ProfileModel(
        name: json['UserName'],
        empId: json['CardId'],
        mobile: json['Mobile'],
        fatherName: json['FatherName'],
        qualification: json['Qualification'],
        emailId: json['EmailId'],
        aadhar: json['Aadhaar'],
        address: json['Address'],
        pan: json['PAN'],
        uan: json['UAN']);
  }
}
