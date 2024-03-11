
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rollcallapp/common/http.service.dart';
import 'package:rollcallapp/common/props.dart';
import 'package:rollcallapp/common/request.body.dart';
import 'package:rollcallapp/models/ExpenseType.dart';
import 'package:rollcallapp/models/attendancemodel.dart';
import 'package:rollcallapp/models/leavemodel.dart';
import 'package:rollcallapp/models/leavesumarymodel.dart';
import 'package:rollcallapp/models/leavetypemodel.dart';
import 'package:rollcallapp/models/loginmodel.dart';
import 'package:rollcallapp/models/profilemodel.dart';
import 'package:rollcallapp/models/punchresultmodel.dart';
import 'package:rollcallapp/models/regexpense.dart';
import 'package:rollcallapp/models/resultmodel.dart';
import 'package:rollcallapp/models/statusmodel.dart';
import 'package:rollcallapp/models/usermodel.dart';
import 'package:rollcallapp/common/common.util.dart';


class RestService {
  HttpService httpService = HttpService();
  Geolocator geolocator = Geolocator();

  Future<UserModel> getUser(
      String userName, String password, String deviceId) async {
    RequestBody reqBody = RequestBody();
    reqBody.url =
        "login/getuserwithdevice?UserName=$userName&Password=$password&DeviceId=$deviceId";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);
    return UserModel.fromJson(response!.data);
  }

  Future<UserModel> getUserNoDeviceId(
      String userName, String password) async {
    RequestBody reqBody = RequestBody();
    reqBody.url =
        "login/getuser?UserName=$userName&Password=$password";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);
    return UserModel.fromJson(response!.data);
  }

  Future<UserModel?> getMobileUser(
      LoginModel login) async {
    RequestBody reqBody = RequestBody();
    reqBody.url ="login/postmobileuserlogin";
    reqBody.type = "POST";
    reqBody.reqData = login.toMap();
    final response = await httpService.restService(reqBody);
    bool status = response!.data["Status"];
    if(status)
      return UserModel.fromJson(response.data["ResultData"]);
    else
      return null;
  }


  

  Future<List<LeaveTypeModel>> getLeaveTypes(int superId) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "Employee/GetLeaveTypes/$superId";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);

    List<LeaveTypeModel> lvtyps = <LeaveTypeModel>[];
    for (var lvtp in response?.data) {
      lvtyps.add(LeaveTypeModel.fromJson(lvtp));
    }
    return lvtyps;
  }

  Future<bool> getNextPunchType(int superid, int regid) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "Employee/GetNextPunchType/$superid/$regid";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);
    bool isInPunch = response?.data.toString().toLowerCase() == 'true';
    return isInPunch;
  }

  Future<bool> processAttendance(int superid, int regid) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "Employee/GetProcessAttendance/$superid/$regid";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);
    bool isInPunch = response?.data.toString().toLowerCase() == 'true';
    return isInPunch;
  }

/*  Future<AddressModel> getAddress(double latitude, double longitude) async {
    RequestBody reqBody = RequestBody();
    reqBody.url =
        "${Prop.mapAPI}geocode/json?latlng=$latitude,$longitude&sensor=true&key=${Prop.mapKey}";
    reqBody.type = "GET";
    reqBody.isEndPointIncluded = true;
    final response = await httpService.restService(reqBody);
    return new AddressModel.fromJson(response.data);
  }*/

/*
  Future<String> getLocationAddress(double latitude, double longitude) async {
   List<Placemark> p = await geolocator.placemarkFromCoordinates(
          latitude, longitude);
      Placemark place = p[0];  
      String _currentAddress ="${place.name}, ${place.thoroughfare}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}.";
    return _currentAddress;
  }
*/

 

/*  Future<List<AttendanceModel>> getAttendance(int regid, String superid) async {
    RequestBody reqBody = RequestBody();
    reqBody.url =
        "employee/getempattendance?SuperId=$superid&RegistrationId=$regid";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);
    List<AttendanceModel> atts = new List<AttendanceModel>();
    for (var attjson in response.data) {
      atts.add(new AttendanceModel.fromJson(attjson));
    }
    return atts;
  }*/

  Future<List<LeaveSummaryModel>> getLeaveSummaryByType(
      int superId, int regId) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "employee/getleavesummarybytype/$superId/$regId";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);
    List<LeaveSummaryModel> lvsm = <LeaveSummaryModel>[];
    for (var attjson in response!.data) {
      lvsm.add(new LeaveSummaryModel.fromJson(attjson));
    }
    return lvsm;
  }

  Future<ProfileModel> getEmployeeProfile(int superId, int regId) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "employee/getregdetails/$superId/$regId";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);
    return new ProfileModel.fromJson(response!.data);
  }

Future<StatusModel> postEmailAlert(int superid, int regid,String commants,String username,String badge) async {
  RequestBody reqBody = RequestBody();
  reqBody.url = "login/postsendemailreq";
  reqBody.type = "POST";
  final reqData = {
      "superidstr": superid.toString(),
      "regidstr": regid.toString(),      
      "commants":commants,
      "username":username,
       "Badge":badge    
    };
    reqBody.reqData = reqData;    
    final response = await httpService.restService(reqBody);    
    return StatusModel.fromJson(response!.data);
  }

  Future<ResultModel> postLeave(LeaveModel leave) async {
    RequestBody reqBody = RequestBody();
    reqBody.type = "POST";
    reqBody.url = 'Employee/PostLeave';
    final reqData = {
      "SuperId": leave.superId.toString(),
      "RegistrationId": leave.regId.toString(),
      "LeaveType": leave.leaveTypeId.toString(),
      "StartDate": CommonUtil.toyyyyMMdd(leave.startDate),
      "EndDate": CommonUtil.toyyyyMMdd(leave.endDate),
      "Comments": leave.comments,
      "IsHalfDay": /*leave.isHalfDay*/"",
      "UpdatedBy": leave.updatedBy
    };
    reqBody.reqData = reqData;
    final response = await httpService.restService(reqBody);
    return ResultModel.fromJson(response!.data);
  }

  Future<PunchResultModel> postAttendance(String superid, String regid,
      double lat, double long, String address, String notes) async {
    RequestBody reqBody = RequestBody();
    reqBody.type = "POST";
    reqBody.url = "Employee/PostGpsPunch";
    String datetime = CommonUtil.toyyyyMMddHHMM(DateTime.now());
    final swipe = {
      "SuperId": superid,
      "RegistrationId": regid,
      "PunchDateTime": datetime,
      "Longitude": long,
      "Latitude": lat,
      "address": address,
      "notes": notes,
    };
    reqBody.reqData = swipe;
    final response = await httpService.restService(reqBody);
    return new PunchResultModel.fromJson(response!.data);
  }

  Future<PunchResultModel> postQRAttendance(String superid, String regid,
      double lat, double long, String address, String notes) async {
    RequestBody reqBody = RequestBody();
    reqBody.type = "POST";
    reqBody.url = "Employee/PostQRCodeGpsPunch";
    String datetime = CommonUtil.toyyyyMMddHHMM(DateTime.now());
    final swipe = {
      "SuperId": superid,
      "RegistrationId": regid,
      "PunchDateTime": datetime,
      "Longitude": long,
      "Latitude": lat,
      "address": address,
      "notes": notes,
    };
    reqBody.reqData = swipe;
    final response = await httpService.restService(reqBody);
    return new PunchResultModel.fromJson(response!.data);
  }


  

  Future<StatusModel> postPassword(
      int superid, int regid, String oldPwd, String newPwd) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "Login/PostPassword";
    reqBody.type = "POST";
    final reqData = {
      "SuperId": superid.toString(),
      "RegId": regid.toString(),
      "OldPassword": oldPwd,
      "NewPassword": newPwd
    };
    reqBody.reqData = reqData;
    final response = await httpService.restService(reqBody);
    return new StatusModel.fromJson(response!.data);
  }

  Future<StatusModel> saveExpense(RegExpense exps) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "employee/SaveRegExpense";
    reqBody.type = "POST";
    Map<String, dynamic> exp = exps.toMap();
    final reqData = exp;
    reqBody.reqData = reqData;
    print(reqBody.reqData);
    final response = await httpService.restService(reqBody);
    return new StatusModel.fromJson(response!.data);
  }

  Future<StatusModel> updateExpense(RegExpense exps) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "employee/UpdateRegExpense";
    reqBody.type = "POST";
    final reqData = exps;
    reqBody.reqData = reqData.toMap();
    print(reqBody.reqData);
    final response = await httpService.restService(reqBody);
    return new StatusModel.fromJson(response!.data);
  }


  Future<List<RegExpense>> getRegExpenses(
      int superId, int regId) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "employee/GetRegExpenses/$superId/$regId";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);
    List<RegExpense> lvsm = <RegExpense>[];
    for (var attjson in response!.data) {
      lvsm.add(new RegExpense.fromJson(attjson));
    }
    return lvsm;
  }

  Future<List<ExpenseType>> getExpensesType(
      int superId) async {
    RequestBody reqBody = RequestBody();
    reqBody.url = "employee/getexpensetypes/$superId";
    reqBody.type = "GET";
    final response = await httpService.restService(reqBody);
    List<ExpenseType> lvsm = <ExpenseType>[];
    for (var attjson in response!.data) {
      lvsm.add(new ExpenseType.fromJson(attjson));
    }
    return lvsm;
  }

/*
  Future<String> uploadProfileImage(File file,int orgId,int regId,int userId) async {
    RequestBody reqBody = RequestBody();   
    reqBody.url = "member/uploadimage";
    reqBody.type = "POST";    
    FormData formData = new FormData.fromMap({
        "image": await MultipartFile.fromFile(file.toString(),filename: basename(file.path)),
        "orgId":orgId,
        "regId":regId,
        "userId":userId
    });
   
    reqBody.reqData = formData;
    final response = await httpService.restService(reqBody);    
    if(response.data['Status'] == true){
      return response.data['ResultData'];
    }
    return null;
  }
*/

  

  // Future<String> uploadProfileImage(File file,int superid,int regId,int expenseId) async {
  //   RequestBody reqBody = RequestBody();
  //   reqBody.url = "employee/upload/image";
  //   reqBody.type = "POST";    

  //   FormData formData = new FormData.fromMap({
  //     "image": await MultipartFile.fromFile(file.relativePath, filename: file.name,),
  //       "superid":superid,
  //       "regId":regId,
  //       "expenseId":expenseId
  //   });
   
  //   reqBody.reqData = formData;
  //   final response = await httpService.restService(reqBody);    
  //   if(response.data['Result'] == true){
  //     return response.data['SuccessMessage'];
  //   }
  //   return response.data['ErrorMessage'];
  // }
}
