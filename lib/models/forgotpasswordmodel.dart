class ForgotPasswordModel{  
  final int regId;
  final int superId;
  final String newPassword;

  ForgotPasswordModel({required this.regId,required this.superId,required this.newPassword});

//final items = (data['items'] as List).map((i) => new CardInfo.fromJson(i));
  factory ForgotPasswordModel.fromJson(Map<String,dynamic> json){
    return new ForgotPasswordModel(
      regId:json['RegId'],      
      superId: json['SuperId'],
      newPassword: json['NewPassword']     
    );
  }  
}