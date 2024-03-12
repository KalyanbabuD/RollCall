class PunchResultModel {
  bool? result;
  String? errorMessage;
  String? successMessage;

  PunchResultModel({
     this.result,
     this.errorMessage,
     this.successMessage,
  });

  factory PunchResultModel.fromJson(Map<String, dynamic> json) {
    return new PunchResultModel(
        result: json['Result'],
        errorMessage: json['ErrorMessage'],
        successMessage: json['SuccessMessage']);
    }

}
