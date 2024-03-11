import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import '../models/statusmodel.dart';
import '../models/constants.dart';

class ChangePwdPage extends StatefulWidget {
  ChangePwdPage({Key? key, this.regid, this.superid}) : super(key: key);

  final int? regid;
  final int? superid;

  ChangePwdPageState createState() => new ChangePwdPageState();
}

class ChangePwdPageState extends State<ChangePwdPage> {
  bool isLoading = false;
  TextEditingController _oldpwdctrl = new TextEditingController();
  TextEditingController _newpwdctrl = new TextEditingController();

  Future<StatusModel> postPassword(
      int superid, int regid, String oldPwd, String newPwd) async {
    final String _url = Constants.apiUrl + 'Login/PostPassword';

    final response = await http.post(Uri.parse(_url), body: {
      "SuperId": superid.toString(),
      "RegId": regid.toString(),
      "OldPassword": oldPwd,
      "NewPassword": newPwd
    });
    final responseJson = json.decode(response.body);
    return new StatusModel.fromJson(responseJson);
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

  void onChangeClick() {
    setState(() {
      isLoading = true;
    });

    Future<StatusModel> pwdFuture = postPassword(
        widget.superid!, widget.regid!, _oldpwdctrl.text, _newpwdctrl.text);

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
      _userDialog('Unable to change password', 'Retry').then((temp) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.indigo,
          title: new Text("Change Password"),
        ),
        body: isLoading
            ? new Center(
                child: new CircularProgressIndicator(
                  backgroundColor: Colors.indigo,
                ),
              )
            : new ListView(
                children: <Widget>[
                  new Container(
                      padding: const EdgeInsets.all(40.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Theme(
                            data: new ThemeData(
                              brightness: Brightness.light,
                            ),
                            // isMaterialAppTheme: true,
                            child: new Column(
                              children: <Widget>[
                                new Form(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: new Column(
                                    children: <Widget>[
                                      new TextFormField(
                                        decoration: new InputDecoration(
                                            labelText: 'Enter Old Password',
                                            fillColor: Colors.white),
                                        keyboardType: TextInputType.text,
                                        controller: _oldpwdctrl,
                                      ),
                                      new TextFormField(
                                        decoration: new InputDecoration(
                                            labelText: 'Enter New Password',
                                            fillColor: Colors.white),
                                        keyboardType: TextInputType.text,
                                        controller: _newpwdctrl,
                                      ),
                                      new Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
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
                                            new Icon(Icons.settings),
                                            new Text('Change',
                                                style: new TextStyle(
                                                    fontSize: 20.0))
                                          ],
                                        ),
                                        onPressed: onChangeClick,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ));
  }
}
