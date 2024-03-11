class PunchResultModel {
  bool result;
  String errorMessage;
  String successMessage;

  PunchResultModel({
    required this.result,
    required this.errorMessage,
    required this.successMessage,
  });

  factory PunchResultModel.fromJson(Map<String, dynamic> json) {
    return new PunchResultModel(
        result: json['Result'],
        errorMessage: json['ErrorMessage'],
        successMessage: json['SuccessMessage']);
    }

}
