class StatusModel{
  final bool result;
  final String errormessage;
  final String successmesage;

  StatusModel({required this.result,required this.errormessage,required this.successmesage});

  factory StatusModel.fromJson(Map<String,dynamic> json){
    return new StatusModel(
      result:  json["Result"],
      errormessage: json["ErrorMessage"],
      successmesage: json["SuccessMessage"]
    );
  }
}