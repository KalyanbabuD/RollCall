import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rollcallapp/common/database.service.dart';
import 'package:rollcallapp/common/rest.service.dart';
import 'package:rollcallapp/models/usermodel.dart';
import 'package:rollcallapp/pages/apprate.dart';
import 'package:rollcallapp/pages/attendance.dart';
import 'package:rollcallapp/pages/changepassword.dart';
import 'package:rollcallapp/pages/dayinout.dart';
import 'package:rollcallapp/pages/expensereport.dart';
import 'package:rollcallapp/pages/expenses.dart';
import 'package:rollcallapp/pages/feedbackpage.dart';
import 'package:rollcallapp/pages/leave.dart';
import 'package:rollcallapp/pages/leavesummary.dart';
import 'package:rollcallapp/pages/profile.dart';

class MenuListView extends StatefulWidget {
 
  MenuListView({Key? key}) : super(key: key);

  @override
  _MenuListViewState createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  //UserModel _userModel;
  LocalStorage storage = new LocalStorage("myrollcall");
  DatabaseService dbSvc = DatabaseService();
  RestService rest = RestService();
  String status = "Please wait";
  UserModel? userModel;

  void _loadDataFromLocal() {
    this.dbSvc.getUserData().then((data) {
      setState(() {
        this.userModel = data;
      });      
    }).catchError((error) {

    });
  }

  
  @override
  void initState() {
    super.initState();
   _loadDataFromLocal();   
  }
  

  void _navigateToDayInOuts() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => DayInoutPage(
              regid: this.userModel!.registrationId,
              emailid: this.userModel!.emailId,
              superid: this.userModel!.superId,
              username: this.userModel!.userName,
            )));
  }

  void _navigateToProfilePage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ProfilePage(
              regid: this.userModel!.registrationId,
              superid: this.userModel!.superId,
            )));
  }

  void _navigateToAttendancePage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AttendancePage(
              regid: this.userModel!.registrationId,
              emailid: this.userModel!.emailId,
              superid: this.userModel!.superId,
              username: this.userModel!.userName,
              appType: this.userModel!.appType,
            )));
  }

  void _navigateToLeaveSummaryPage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => LeaveSummaryPage(
            username: this.userModel!.userName,
            superid: this.userModel!.superId,
            regid: this.userModel!.registrationId,
            emailid: this.userModel!.emailId)));
  }

  void _navigateToChangePassword() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ChangePwdPage(
              regid: this.userModel!.registrationId,
              superid: this.userModel!.superId,
            )));
  }

  void _navigateToAppRatePage() {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => AppRate()));
  }

  void _navigateToFeedBackPage() {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => FeedBack()));
  }

  void _navigateToLeavePage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => LeavePage(
              regid: this.userModel!.registrationId,
              superid: this.userModel!.superId,
            )));
  }

  void _navigateToExpensePage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            ExpensePage(userdata: this.userModel!,regexp: null,isEdit: false,)));
  }
  void _navigateToExpenseReportPage() {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            ExpenseReport(userdata: this.userModel!,)));
  }

  Widget buildLeaveSubmissionMenu() {
    if (this.userModel!.appType == "POR" ||
        this.userModel!.appType == "STD") {
      return InkWell(
        onTap: () {
          _navigateToLeavePage();
        },
        child: ListTile(
          title: Text('Leave Submission'),
          leading: Icon(
            Icons.note,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

    Widget buildExpenseReportMenu() {
    if (this.userModel!.appType == "POR" ||
        this.userModel!.appType == "STD") {
      return InkWell(
          onTap: () {
            _navigateToExpenseReportPage();
          },
          child: ListTile(
            title: Text('Expense Report'),
            leading: Icon(
              Icons.attach_money,
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
    } else {
      return Container();
    }
  }

    Widget buildExpenseSubmissionMenu() {
    if (this.userModel!.appType == "POR" ||
        this.userModel!.appType == "STD") {
      return   InkWell(
          onTap: () {
            _navigateToExpensePage();
          },
          child: ListTile(
            title: Text('Expense'),
            leading: Icon(Icons.attach_money, color: Theme.of(context).primaryColor),
          ),
        );
    } else {
      return Container();
    }
  }

    Widget _loadData() {
    if (this.userModel! == null) {
      return new Container(
          child: Center(
        child: Text(
          "Loading...",
          style: TextStyle(color: Colors.indigo, fontSize: 20.0),
        ),
      ));
    }
    return  new ListView(
      children: <Widget>[
//            header
        new UserAccountsDrawerHeader(
          accountName: Text(this.userModel!.userName!),
          accountEmail: Text(this.userModel!.emailId!),
          currentAccountPicture: GestureDetector(
            child: new CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
        ),

//            body
        InkWell(
          onTap: () {
            _navigateToAttendancePage();
          },
          child: ListTile(
            title: Text('Home Page'),
            leading: Icon(
              Icons.home,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

        InkWell(
          onTap: () {
            _navigateToProfilePage();
          },
          child: ListTile(
            title: Text('Profile'),
            leading: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

        InkWell(
          onTap: () {
            _navigateToDayInOuts();
          },
          child: ListTile(
            title: Text('Attendance Report'),
            leading: Icon(
              Icons.alarm,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      
          
       
        buildExpenseReportMenu(),
        buildExpenseSubmissionMenu(),
        buildLeaveSubmissionMenu(),

        InkWell(
          onTap: () {
            _navigateToLeaveSummaryPage();
          },
          child: ListTile(
            title: Text('Leave Summary'),
            leading: Icon(
              Icons.account_box,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

        InkWell(
          onTap: () {
            _navigateToChangePassword();
          },
          child: ListTile(
            title: Text('Change Password'),
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      
        Divider(),
        InkWell(
          onTap: () {
            _navigateToAppRatePage();
          },
          child: ListTile(
            title: Text('Rate this app'),
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ),

        InkWell(
          onTap: () {
            _navigateToFeedBackPage();
          },
          child: ListTile(
            title: Text('Feedback'),
            leading: Icon(
              Icons.settings,
              color: Colors.blue,
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: ListTile(
            title: Text('About'),
            leading: Icon(Icons.help, color: Theme.of(context).primaryColor),
          ),
        ),
        //  InkWell(
        //   onTap: () {
        //     cleardata();
        //   },
        //   child: ListTile(
        //     title: Text('Sign Out'),
        //     leading: Icon(Icons.exit_to_app, color: Theme.of(context).primaryColor),
        //   ),
        // ),
        Divider(),
        Container(
          child: Image.asset('images/rc_logo.png'),
        ),
      ],
    );
  }

  // void cleardata(){
  //   dbSvc.dbHelper.deleteDB();
  //   storage.clear();
  //   _navigateToLoginPage();
  // }

  // void _navigateToLoginPage() {
  //   Navigator.of(context).pop();
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) =>
  //           LoginPage()));
  // }

  @override
  Widget build(BuildContext context) {
    return _loadData();
  }
}
