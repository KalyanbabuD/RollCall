class LoginModel{  
  String userName;
  String password;
  String deviceId;

  LoginModel({required this.userName,required this.password,required this.deviceId});

//final items = (data['items'] as List).map((i) => new CardInfo.fromJson(i));
  factory LoginModel.fromJson(Map<String,dynamic> json){
    return new LoginModel(
      userName:json['UserName'],      
      password: json['Password'],
      deviceId: json['DeviceId']     
    );
  }  
  Map<String,dynamic> toMap() => {  
    'UserName': userName,
    'Password':password,
    'DeviceId':deviceId,
  };
}