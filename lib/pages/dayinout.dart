import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../models/attendancemodel.dart';
import '../models/constants.dart';

class DayInoutPage extends StatefulWidget {
  DayInoutPage({Key? key, this.username, this.regid, this.superid, this.emailid})
      : super(key: key);
  final String? username;
  final int? regid;
  final int? superid;
  final String? emailid;
  @override
  DayInoutState createState() => new DayInoutState();
}

class DayInoutState extends State<DayInoutPage> {
  Future<List<AttendanceModel>> getAttendance(int regid, String superid) async {
    final String url = Constants.apiUrl +
        "employee/getempattendance?SuperId=" +
        superid +
        "&RegistrationId=" +
        regid.toString();
    //print(url);
    final response = await http.get(Uri.parse(url));
    final responsejson = json.decode(response.body);
    List<AttendanceModel> atts = <AttendanceModel>[];
    for (var attjson in responsejson) {
      atts.add(new AttendanceModel.fromJson(attjson));
    }
    return atts;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        title: new Text("Attendance Report"),
      ),
      body: new FutureBuilder<List<AttendanceModel>>(
        future: getAttendance(widget.regid!, widget.superid.toString()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  child: new Container(
                    padding: const EdgeInsets.all(15.0),
                    child: new Row(
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundColor: Colors.indigo,
                          child: new Text(snapshot.data
                              !.elementAt(index)
                              .dateOfTransaction
                              !.day
                              .toString()),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                        ),
                        new Column(
                          children: <Widget>[
                            new Text(
                              snapshot.data!
                                      .elementAt(index)
                                      .dateOfTransaction
                                      !.day
                                      .toString() +
                                  "-" +
                                  snapshot.data!
                                      .elementAt(index)
                                      .dateOfTransaction
                                      !.month
                                      .toString() +
                                  "-" +
                                  snapshot.data!
                                      .elementAt(index)
                                      .dateOfTransaction
                                      !.year
                                      .toString(),
                              style: new TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            new Padding(
                                padding: const EdgeInsets.only(bottom: 5.0)),
                            new Row(
                              children: <Widget>[
                                new Text('In: ' +
                                    snapshot.data!.elementAt(index).inTime.toString()),
                                new Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                ),
                                new Text('Out: ' +
                                    snapshot.data!.elementAt(index).outTime)
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          // By default, show a loading spinner
          return new Center(
            child: new CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
