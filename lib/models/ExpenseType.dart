
import 'package:rollcallapp/common/common.util.dart';

class ExpenseType{
  int id;
  int superId; 
  String name;
  String description; 
  bool isActive;
  String createdBy;
  String createdOn;
  String updatedBy;
  String updatedOn;

  ExpenseType({required this.id,required this.superId,required this.name,required this.description,required this.isActive,required this.createdBy,required this.createdOn,required this.updatedBy,required this.updatedOn});
  
   factory ExpenseType.fromJson(Map<String,dynamic> json){
    return new ExpenseType(
      id: json['Id'],
      superId: json['SuperId'],
      name: json['Name'],
      description: json['Description'],
      isActive: json['IsActive'],
      createdBy:json['CreatedBy'],
      createdOn: json['CreatedOn'],
      updatedBy:json['UpdatedBy'],
      updatedOn: json['UpdatedOn']
    );
  }

  Map<String,dynamic> toMap() => {    
    'Id':id,
    'SuperId': superId,
    'Name':name,
    'Description':description,
    'IsActive':isActive,
    'CreatedBy':createdBy,
    'CreatedOn':createdOn,
    'UpdatedBy':updatedBy,
    'UpdatedOn':updatedOn
  };

  static List<ExpenseType>? parseToList(
      List<dynamic> dynamicList) {
    if (dynamicList == null) return null;
    List<Map<String, dynamic>> jsonArray =
        CommonUtil.getListOfMaps(dynamicList);
    List<ExpenseType> ods = <ExpenseType>[];
    for (Map<String, dynamic> odjson in jsonArray) {
      ods.add(new ExpenseType.fromJson(odjson));
    }
    return ods;
  }

  static List<Map<String, dynamic>> parseToMapArray(
      List<ExpenseType> odts) {
    List<Map<String, dynamic>> odtarry = <Map<String, dynamic>>[];
    if (odts != null && odts.length > 0) {
      // ignore: sdk_version_set_literal
      odts.forEach((odt) => {odtarry.add(odt.toMap())});
    }
    return odtarry;
  }

}