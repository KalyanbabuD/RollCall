

import 'package:rollcallapp/models/passcodemodel.dart';
import 'package:rollcallapp/models/usermodel.dart';

import 'databasehelper.dart';

class DatabaseService{
  final dbHelper = DatabaseHelper.instance;

  // Future<List<EmployeeModel>> getEmployees() async{
  //   final rows=  await dbHelper.queryRows("Registrations", null, null);    
  //   List<EmployeeModel> emps = List<EmployeeModel>();
  //   for(var empjson in rows){
  //     emps.add(EmployeeModel.fromJson(empjson));
  //   }
  //   return emps;
  // }

  Future<UserModel> getUserData() async{
    final rows = await dbHelper.queryRows("UserData","",[]);
    return UserModel.fromJson(rows.first);
  }

  Future<PassCodeModel?> getPassCodeData() async{
    final rows = await dbHelper.queryRows("PassCode","",[]);
    if(rows == null){
      return null;
    }
    else{
      return PassCodeModel.fromJson(rows.first);
    }    
  }

  // Future<List<SwipeModel>> getSwipesToPush() async{
  //   final rows = await dbHelper.queryRows("Swipes", 'IsPushed=?', [0]);
  //   return SwipeModel.parseToSwipeList(rows);
  // }

  Future<UserModel?> saveUser(UserModel user) async{
    final result = await dbHelper.insert("UserData", user.toJson());
    if(result > 0){
      return user;   
    }
    else{
     return null;
    }
  }

   Future<PassCodeModel?> savePasscode(PassCodeModel user) async{
    final result = await dbHelper.insert("PassCode", user.toMap());
    if(result > 0){
      return user;   
    }
    else{
     return null;
    }
  }

  // Future<int> updateSwipesAsPushed(List<SwipeModel> swipes){
  //   String swipeIds = "";
  //   swipes.forEach((swipe){
  //     swipeIds += swipe.id.toString();
  //     if(swipes.indexOf(swipe) < (swipes.length -1) ){
  //       swipeIds += ",";
  //     }
  //   });
  //   final result = dbHelper.updateRaw("Update Swipes set IsPushed = 1 where Id in ($swipeIds)");
  //   return result;
  // }

  Future<int> deleteUser(int registrationId){
    String query = "Delete from UserData where RegistrationId = $registrationId ";
    final result = dbHelper.deleteRaw(query);
    return result;
  }
}