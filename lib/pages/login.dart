import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// import 'package:url_launcher/url_launcher.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/attendance.dart';
import '../models/usermodel.dart';
import '../models/constants.dart';
import '../pages/requestadmin.dart';

String finaluser='';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
    this.username,
    this.regid,
    this.superid,
    this.emailid,
    this.appType,
  }) : super(key: key);
  final String? username;
  final int? regid;
  final int? superid;
  final String? emailid;
  final String? appType;
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  String _deviceid = 'Unknown';

  @override
  void initState() {
    getValidationData().whenComplete(() async {
      Timer(Duration(seconds: 0),
          (() => Get.to(finaluser == null ? LoginPage() : AttendancePage())));
    });
    super.initState();

    // initDeviceId();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('userId');
    setState(() {
      finaluser = obtainedEmail!;
    });
    print(finaluser);
  }

  Future<void> initDeviceId() async {
    String? deviceid;

    deviceid = await PlatformDeviceId.getDeviceId;

    if (!mounted) return;

    setState(() {
      _deviceid = deviceid!;
    });
  }

  Future<Null> _usernotFound() async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) => new AlertDialog(
              title: new Text('Message'),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text('Please verify username and password'),
                  ],
                ),
              ),
              actions: <Widget>[
                new TextButton(
                  child: new Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<UserModel> getUser(
    String userName,
    String password,
  ) async {
    final String _url = Constants.apiUrl +
        "login/getuser?UserName=" +
        userName +
        "&Password=" +
        password;
    // "&DeviceId=" +
    // _deviceid;
    // print(_url);
    final response = await http.get(Uri.parse(_url));
    print(response.body);
    final responseJson = json.decode(response.body);

    return new UserModel.fromJson(responseJson);
  }

  void onLoginClick() {
    setState(() {
      isLoading = true;
    });
    getUser(
      _username.text,
      _password.text,
    ).then(
      (loginuser) {
        isLoading = false;
        if (loginuser.registrationId != null) {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new AttendancePage(
                username: loginuser.userName,
                superid: loginuser.superId,
                regid: loginuser.registrationId,
                emailid: loginuser.emailId,
                appType: loginuser.appType,
              ),
            ),
          );
        } else {
          Future<Null> userinput = _usernotFound();
          userinput.then((temp) {
            setState(() {
              isLoading = false;
            });
          });
        }
      },
    );
  }
//Login User with device Id :
  // void onLoginClick() {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   print('UserName: ' +
  //       _username.text +
  //       ' Password: ' +
  //       _password.text +
  //       'Deviceid: ' +
  //       _deviceid);
  //   getUser(
  //     _username.text, _password.text,
  //     //_deviceid,
  //   ).then((loginuser) {
  //     isLoading = false;
  //     if (loginuser.registrationId > 0 &&
  //         (loginuser.deviceId == null || loginuser.deviceId == _deviceid)) {
  //       Navigator.push(
  //           context,
  //           new MaterialPageRoute(
  //               builder: (context) => new AttendancePage(
  //                     username: loginuser.userName,
  //                     superid: loginuser.superId,
  //                     regid: loginuser.registrationId,
  //                     emailid: loginuser.emailId,
  //                     appType: loginuser.appType,
  //                   )));
  //     } else if (loginuser.registrationId > 0 &&
  //         loginuser.deviceId != _deviceid) {
  //       Navigator.push(
  //           context,
  //           new MaterialPageRoute(
  //               builder: (context) => new RequestAdminPage(
  //                     username: loginuser.userName,
  //                     superid: loginuser.superId,
  //                     regid: loginuser.registrationId,
  //                     emailid: loginuser.emailId,
  //                     badge: loginuser.badge,
  //                   )));
  //     } else {
  //       Future<Null> userinput = _usernotFound();
  //       userinput.then((temp) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: isLoading
          ? new Center(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            )
          : new ListView(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.all(40.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Image(
                        image: new AssetImage('images/rc_logo.png'),
                        width: 280.0,
                        height: 150.0,
                      ),
                      new Theme(
                        data: new ThemeData(
                          brightness: Brightness.light,
                        ),
                        // isMaterialAppTheme: true,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                            ),
                            new Form(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: new Column(
                                children: <Widget>[
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                        labelText: 'Enter UserId',
                                        fillColor: Colors.white),
                                    keyboardType: TextInputType.text,
                                    controller: _username,
                                  ),
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                        labelText: 'Enter Password',
                                        fillColor: Colors.white),
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    controller: _password,
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                  ),
                                  new MaterialButton(
                                      color: Colors.indigo,
                                      textColor: Colors.white,
                                      splashColor: Colors.black,
                                      height: 40.0,
                                      minWidth: 150.0,
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          new Icon(Icons.forward),
                                          new Text('Login',
                                              style:
                                                  new TextStyle(fontSize: 20.0))
                                        ],
                                      ),
                                      onPressed: () async {
                                        onLoginClick();
                                        final SharedPreferences
                                            sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();
                                        sharedPreferences.setString(
                                            'userId', _username.text);
                                      }),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(50),
                                    child:
                                        Image.asset('images/perennialcode.png'),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _TermsURL();
                                          },
                                          child: Wrap(
                                            children: [
                                              Text(
                                                'Terms & ',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _PrivacypolicyURL();
                                          },
                                          child: Wrap(
                                            children: [
                                              Text(
                                                'Privacy Policy',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

//Terms and conditions link
  _TermsURL() async {
    const url = 'http://www.perennialcode.com/termandconditions.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

//privacy policy link
  _PrivacypolicyURL() async {
    const url = 'http://www.perennialcode.com/privacypolicy.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
