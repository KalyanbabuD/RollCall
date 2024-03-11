import 'package:rollcallapp/common/common.util.dart';

class PassCodeModel{
  int id;
  String code;
  PassCodeModel({required this.id,required this.code});

   factory PassCodeModel.fromJson(Map<String,dynamic> json){
    return new PassCodeModel(
      id: json['Id'],
      code: json['Password'],
    );
  }

   Map<String,dynamic> toMap() => {    
    'Id':id,
    'Password': code,
  };

   static List<PassCodeModel>? parseToUserList(
      List<dynamic> dynamicList) {
    if (dynamicList == null) return null;
    List<Map<String, dynamic>> jsonArray =
        CommonUtil.getListOfMaps(dynamicList);
    List<PassCodeModel> ods = <PassCodeModel>[];
    for (Map<String, dynamic> odjson in jsonArray) {
      ods.add(new PassCodeModel.fromJson(odjson));
    }
    return ods;
  }

  

}