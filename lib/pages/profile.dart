import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import '../models/constants.dart';
import '../models/profilemodel.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, this.regid, this.superid}) : super(key: key);

  final int? regid;
  final int? superid;

  ProfilePageState createState() => new ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Future<ProfileModel> getEmployeeProfile(int superId, int regId) async {
    final String _url = Constants.apiUrl +
        "Employee/GetRegDetails/" +
        superId.toString() +
        '/' +
        regId.toString();

    final response = await http.get(Uri.parse(_url));
    final responseJson = json.decode(response.body);

    return new ProfileModel.fromJson(responseJson);
  }

  TextStyle _labelStyle = new TextStyle(
    fontSize: 25.0,
    // fontWeight: FontWeight.bold,
    // fontFamily: 'SourceSansPro',
    color: Colors.grey,
  );
  TextStyle _valueStyle = new TextStyle(
    fontSize: 20.0,
    fontFamily: 'SourceSansPro',
    color: Colors.blue.shade300,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.5,
  );
  Divider _listdivider = new Divider(
    color: Colors.black45,
  );

  @override
  build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Profile'),
          backgroundColor: Colors.indigo,
        ),
        body: new FutureBuilder<ProfileModel>(
          future: getEmployeeProfile(widget.superid!, widget.regid!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView(
                padding: const EdgeInsets.all(10.0),
                children: <Widget>[
                  new ListTile(
                    title: new Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: AssetImage('images/profile.png'),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            new Text(
                              '  UserName : ',
                              style: _labelStyle,
                              // textAlign: TextAlign.left,
                            ),
                            new Text(
                              snapshot.data!.name == null
                                  ? ''
                                  : snapshot.data!.name,
                              style: _valueStyle,
                              textDirection: TextDirection.ltr,
                            ),
                            _listdivider,
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: Colors.blue,
                        ),
                        title: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              'Mobile',
                              style: _labelStyle,
                            ),
                            new Text(
                              snapshot.data!.mobile == null
                                  ? ''
                                  : snapshot.data!.mobile,
                              style: _valueStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.assignment_ind_outlined,
                          color: Colors.blue,
                        ),
                        title: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              'Employee Id',
                              style: _labelStyle,
                            ),
                            new Text(
                              snapshot.data!.empId == null
                                  ? ''
                                  : snapshot.data!.empId,
                              style: _valueStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.person_search_rounded,
                          color: Colors.blue,
                        ),
                        title: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              'Father Name',
                              style: _labelStyle,
                            ),
                            new Text(
                              snapshot.data!.fatherName == null
                                  ? ''
                                  : snapshot.data!.fatherName,
                              style: _valueStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.mail,
                          color: Colors.blue,
                        ),
                        title: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              'EmailID',
                              style: _labelStyle,
                            ),
                            new Text(
                              snapshot.data!.emailId == null
                                  ? ''
                                  : snapshot.data!.emailId,
                              style: _valueStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.home_rounded,
                          color: Colors.blue,
                        ),
                        title: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              'Address',
                              style: _labelStyle,
                            ),
                            new Text(
                              snapshot.data!.address == null
                                  ? ''
                                  : snapshot.data!.address,
                              style: _valueStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.add_card_rounded,
                          color: Colors.blue,
                        ),
                        title: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              'Aadhar',
                              style: _labelStyle,
                            ),
                            new Text(
                              snapshot.data!.aadhar == null
                                  ? ''
                                  : snapshot.data!.aadhar,
                              style: _valueStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.add_card_rounded,
                          color: Colors.blue,
                        ),
                        title: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              'PAN',
                              style: _labelStyle,
                            ),
                            new Text(
                              snapshot.data!.pan == null
                                  ? ''
                                  : snapshot.data!.pan,
                              style: _valueStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.account_balance_rounded,
                          color: Colors.blue,
                        ),
                        title: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              'UAN',
                              style: _labelStyle,
                            ),
                            new Text(
                              snapshot.data!.uan == null
                                  ? ''
                                  : snapshot.data!.uan,
                              style: _valueStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return new Center(
              child: new CircularProgressIndicator(),
            );
          },
        ));
  }
}
