import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:rollcallapp/models/constants.dart';
import 'package:rollcallapp/models/leavemodel.dart';
import 'package:rollcallapp/models/leavetypemodel.dart';
import 'package:rollcallapp/models/resultmodel.dart';
import 'package:rollcallapp/utils/utils.dart';

Future<List<LeaveTypeModel>> getLeaveTypes(int superId) async {
  final String _url =
      Constants.apiUrl + "Employee/GetLeaveTypes/" + superId.toString();
  final response = await http.get(Uri.parse(_url));
  final responseJson = json.decode(response.body);

  List<LeaveTypeModel> extps = <LeaveTypeModel>[];
  for (var extpjson in responseJson) {
    extps.add(new LeaveTypeModel.fromJson(extpjson));
  }
  return extps;
}

Future<ResultModel> postLeave(LeaveModel leave) async {
  final String _url = Constants.apiUrl + "Employee/PostLeave";
  final response = await http.post(
    Uri.parse(_url),
    body: {
      "SuperId": leave.superId.toString(),
      "RegistrationId": leave.regId.toString(),
      "LeaveType": leave.leaveTypeId.toString(),
      "StartDate": toyyyyMMdd(leave.startDate),
      "EndDate": toyyyyMMdd(leave.endDate),
      "Comments": leave.comments,
    },
  );
  final responseJson = json.decode(response.body);
  return ResultModel.fromJson(responseJson);
}
