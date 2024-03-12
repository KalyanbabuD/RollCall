import 'dart:convert';

class UserModel {
  final int? superId;
  final String? userName;
  final String? emailId;
  final int? registrationId;
  final String? appType;
  // final String deviceId;
  final String? badge;

  UserModel({
    this.superId,
    this.userName,
    this.emailId,
    this.registrationId,
    this.appType,
    // this.deviceId,
    this.badge,
  });

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
    return new UserModel(
      superId: parsedJson['SuperId'],
      userName: parsedJson['UserName'],
      emailId: parsedJson['EmailId'],
      registrationId: parsedJson['RegistrationId'],
      appType: parsedJson['AppType'],
      // deviceId: parsedJson['DeviceId'],
      badge: parsedJson['Badge'],
    );
  }
  Map<String, dynamic> toJson() => {
        "SuperId": superId,
        'UserName': userName,
        'EmailId': emailId,
        'RegistrationId': registrationId,
        'AppType': appType,
        // 'DeviceId': deviceId,
        'Badge': badge,
      };
}
