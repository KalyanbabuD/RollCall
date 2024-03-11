import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/constants.dart';
import '../models/leavesumarymodel.dart';

class LeaveSummaryPage extends StatefulWidget {
  LeaveSummaryPage(
      {Key? key, this.username, this.regid, this.superid, this.emailid})
      : super(key: key);
  final String? username;
  final int? regid;
  final int? superid;
  final String? emailid;

  @override
  LeaveSummaryState createState() => new LeaveSummaryState();
}

class LeaveSummaryState extends State<LeaveSummaryPage> {
  Future<List<LeaveSummaryModel>> getLeaveSummaryByType(
      int superId, int regId) async {
    final String _url = Constants.apiUrl +
        "Employee/GetLeaveSummaryByType/" +
        superId.toString() +
        "/" +
        regId.toString();
    final response = await http.get(Uri.parse(_url));
    final responsejson = json.decode(response.body);
    print(responsejson.toString());
    List<LeaveSummaryModel> lvsm = <LeaveSummaryModel>[];
    for (var attjson in responsejson) {
      lvsm.add(new LeaveSummaryModel.fromJson(attjson));
    }
    return lvsm;
  }

  @override
  Widget build(BuildContext context) {
    Card buildLeaveCard(
        String leaveType, String accrued, String taken, String avilable) {
      return new Card(
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Text(
                leaveType,
                style:
                    new TextStyle(color: Colors.indigoAccent, fontSize: 25.0),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Text(
                        accrued,
                        style: new TextStyle(
                            color: Colors.blueAccent, fontSize: 20.0),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: new Text(
                          'Accrued',
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        taken,
                        style: new TextStyle(
                            color: Colors.blueAccent, fontSize: 20.0),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: new Text(
                          'Taken',
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new Text(
                        avilable,
                        style: new TextStyle(
                            color: Colors.blueAccent, fontSize: 20.0),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: new Text(
                          'Available',
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.indigo,
          title: new Text("Leave Summary"),
        ),
        body: new FutureBuilder<List<LeaveSummaryModel>>(
          future: getLeaveSummaryByType(widget.superid!, widget.regid!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildLeaveCard(
                      snapshot.data!.elementAt(index).leaveType,
                      snapshot.data!.elementAt(index).leavesAccrued.toString(),
                      snapshot.data!.elementAt(index).leavesTaken.toString(),
                      snapshot.data!.elementAt(index).leavesAvailble.toString());
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
        ));
  }
}
