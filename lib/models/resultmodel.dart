class ResultModel{
  final bool status;
  final String successMessage;
  final String errorMessage;

  ResultModel({required this.status,required this.successMessage,required this.errorMessage});

  factory ResultModel.fromJson(Map<String,dynamic> json){    
    return new ResultModel(
      status: json['Result'],
      successMessage: json['SuccessMessage'],
      errorMessage: json['ErrorMessage'],   
    );
  }
}