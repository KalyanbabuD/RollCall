import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rollcallapp/models/statusmodel.dart';
import 'package:rollcallapp/pages/login.dart';
import 'package:http/http.dart' as http;
import '../models/constants.dart';

class RequestAdminPage extends StatefulWidget {
  RequestAdminPage(
      {Key? key,
      this.username,
      this.regid,
      this.superid,
      this.emailid,
      this.badge})
      : super(key: key);

  final String? username;
  final int? regid;
  final int? superid;
  final String? emailid;
  final String? badge;

  @override
  _RequestAdminPageState createState() => new _RequestAdminPageState();
}

class _RequestAdminPageState extends State<RequestAdminPage> {
  bool isLoading = false;
  String value = """<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Roll Call App Activation for Mobile</title>
    <style>
        .body {
            font-family: "Courier New";
        }
		.button {
  background-color: #2903a3; border: none; color: white; padding: 10px 25px; text-align: center; text-decoration: none; display: inline-block;  font-size: 16px;
}
    </style>
</head>
<body>
    <img src="~/RollCallAppServices/Images/31113/logo.png" alt="Rollcall Attendance" >
    <h3 class="body"> Dear Admin, </h3>	
    <p style="font-size:20px" class="body">Kindly Activate My Roll call App Credentials to Changed Mobile.</p>
	<p><b>Comment: </b> #EmpComment#</p>
	<a href="http://devapp.rollcallattendance.com/Views/resetdeviceIdpage.aspx?SuperId=#superid#&RegId=#RegId#" class="button"> Accept</a>
    <h4 class="body">Regarding</h4>
    <h4 class="body">Employee: #Name#</h4>
	<h4 class="body">Badge: #Badge#</h4> 
</body>
</html>
""";
  String defaultText =
      "I want to change my Device please reset the device for roll call attendance";
  TextEditingController _comments = new TextEditingController();

  Future<StatusModel> postEmailAlert(
      int superid,
      int regid,
      String emailSubject,
      String emailBody,
      String commants,
      String username,
      String badge,
      bool ishtml) async {
    final String _url = Constants.apiUrl + 'login/PostSendEmailReq';
    final response = await http.post(Uri.parse(_url), body: {
      "superidstr": superid.toString(),
      "regidstr": regid.toString(),
      "SubjectEmail": emailSubject,
      "BodyEmail": emailBody,
      "commants": commants,
      "username": username,
      "Badge": badge,
      "ishtmlstr": ishtml.toString()
    });
    final responseJson = json.decode(response.body);
    return responseJson;
  }

  Future<Null> _userDialog(String messagetext, String actiontext) async {
    return showDialog<Null>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) => new AlertDialog(
              title: new Text('Message'),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text(messagetext),
                    //new Text('You\’re like me. I’m never satisfied.'),
                  ],
                ),
              ),
              actions: <Widget>[
                new TextButton(
                  child: new Text(actiontext),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void onRequestClick() {
    setState(() {
      isLoading = true;
    });
    Future<StatusModel> pwdFuture = postEmailAlert(
        widget.superid!,
        widget.regid!,
        "Roll Call App Activation for Mobile",
        value,
        _comments.text,
        widget.username!,
        widget.badge!,
        true);

    pwdFuture.then((status) {
      Future<Null> dialogFuture;
      if (status.result) {
        dialogFuture = _userDialog(status.successmesage, 'Ok');
      } else {
        dialogFuture = _userDialog(status.errormessage, 'Retry');
      }

      dialogFuture.then((temp) {
        setState(() {
          isLoading = false;
        });
      });
    });

    pwdFuture.catchError(() {
      _userDialog('Unable to send email', 'Retry').then((temp) {
        setState(() {
          isLoading = false;
        });
      });
    });
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new LoginPage()));
  }

  void onCancelClick() {
    setState(() {
      isLoading = true;
    });

    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Request to admin'),
        ),
        body: isLoading
            ? new Center(
                child: new CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                ),
              )
            : new ListView(
                children: <Widget>[
                  new Container(
                    padding: const EdgeInsets.all(20.0),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          'Looks like your loging in with new mobile!',
                          style:
                              new TextStyle(fontSize: 20.0, color: Colors.blue),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        new Text(
                          'Please send request to admin, to reset your credentials.',
                          style:
                              new TextStyle(fontSize: 20.0, color: Colors.blue),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                        ),
                        TextField(
                          controller: _comments =
                              new TextEditingController(text: defaultText),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                        ),
                        //Text('Request to change for new mobile login'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: onRequestClick,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.all(2.0),
                              ),
                              child: const Text('Request'),
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                            ),
                            ElevatedButton(
                              onPressed: onCancelClick,
                              child: const Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(2.0),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
