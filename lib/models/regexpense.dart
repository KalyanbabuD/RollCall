
import 'package:rollcallapp/common/common.util.dart';

class RegExpense{
  int? id;
  int? superId;
  int? regId;
  String? expenseDate;
  String? reason;
  double? amount;
  double? approvedAmount;
  String? filePath;
  bool? approved;
  int? payPeriodId;
  String? referenceId;
  bool? isActive;
  String? createdBy;
  String? createdOn;
  String? updatedBy;
  String? updatedOn;
  int? expenseTypeId;
  String? expenseType;

  RegExpense({ this.id, this.superId, this.regId, this.expenseDate, this.reason, this.amount, this.approvedAmount, this.filePath, this.approved, this.payPeriodId, this.referenceId, this.isActive, this.createdBy, this.createdOn, this.updatedBy, this.updatedOn, this.expenseTypeId, this.expenseType});
  
   factory RegExpense.fromJson(Map<String,dynamic> json){
    return new RegExpense(
      id: json['Id'],
      superId: json['SuperId'],
      regId: json['RegId'],
      expenseDate: json['ExpenseDate'],
      reason: json['Reason'],
      amount: json['Amount'],
      approvedAmount: json['ApprovedAmount'],
      filePath:json['FilePath'],
      approved: json['Approved'],
      payPeriodId: json['PayPeriodId'],
      referenceId: json['ReferenceId'],
      isActive: json['IsActive'],
      createdBy:json['CreatedBy'],
      createdOn: json['CreatedOn'],
      updatedBy:json['UpdatedBy'],
      updatedOn: json['UpdatedOn'],
      expenseTypeId: json['ExpenseTypeId'],
      expenseType: json['ExpenseType']
    );
  }

  Map<String,dynamic> toMap() => {    
    'Id':id,
    'SuperId': superId,
    'RegId':regId,
    'ExpenseDate':expenseDate,
    'Reason':reason,
    'Amount':amount,
    'ApprovedAmount':approvedAmount,
    'FilePath':filePath,
    'Approved':approved,
    'PayPeriodId': payPeriodId,
    'ReferenceId':referenceId,
    'IsActive':isActive,
    'CreatedBy':createdBy,
    'CreatedOn':createdOn,
    'UpdatedBy':updatedBy,
    'UpdatedOn':updatedOn,
    'ExpenseTypeId':expenseTypeId,
    'ExpenseType':expenseType
  };

  static List<RegExpense>? parseToList(
      List<dynamic> dynamicList) {
    if (dynamicList == null) return null;
    List<Map<String, dynamic>> jsonArray =
        CommonUtil.getListOfMaps(dynamicList);
    List<RegExpense> ods = <RegExpense>[];
    for (Map<String, dynamic> odjson in jsonArray) {
      ods.add(new RegExpense.fromJson(odjson));
    }
    return ods;
  }

  static List<Map<String, dynamic>> parseToMapArray(
      List<RegExpense> odts) {
    List<Map<String, dynamic>> odtarry = <Map<String, dynamic>>[];
    if (odts != null && odts.length > 0) {
      odts.forEach((odt) => {odtarry.add(odt.toMap())});
    }
    return odtarry;
  }

}