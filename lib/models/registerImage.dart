class RegisterImageModel {
  bool status;
  String message;
  String personid;
  String superid;

  RegisterImageModel({
    required this.status,
    required this.message,
    required this.personid,
    required this.superid,
  });

  factory RegisterImageModel.fromJson(Map<String, dynamic> json) {
    return new RegisterImageModel(
        status: json['Status'],
        message: json['Message'],
        superid: json['superid'],
        personid: json['personid']);
  }

}
