import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rollcallapp/pages/attendance.dart';
import 'package:rollcallapp/pages/leave.dart';
import '../Helper/location_helper.dart';
import '../models/punchresultmodel.dart';
import '../models/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class MapViewPage extends StatefulWidget {
  MapViewPage({
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
  MapViewPageState createState() => new MapViewPageState();
}

class MapViewPageState extends State<MapViewPage> {
  bool isLoading = false;
  File? cameraFile;
  String _previewImageUrl = "";

  String address = "";
  String punchtype = 'loading..';
  TextEditingController _notesctrl = new TextEditingController();
  String _currentAddress = "";
  Position? _currentPosition;
  List imagesBase64 = [];

  String error = "";
  List<Widget> widgets = [];

  bool currentWidget = true;

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();

    setNextPunchType(widget.superid!, widget.regid!);
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });

    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
    );

    setState(() {
      print("staticMapImageUrl dsasad " + staticMapImageUrl);
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = '${place.street}, ${place.subLocality}, ${place.administrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  openCamera(BuildContext context) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  setNextPunchType(int superid, int regid) {
    Future<bool> processAttFuture = processAttendance(superid, regid);

    processAttFuture.then((isSuccess) {
      if (isSuccess != null) {
        Future<bool> nextpunchFuture = getNextPunchType(superid, regid);

        nextpunchFuture.then((isIn) {
          setState(() {
            if (isIn != null) {
              if (isIn)
                punchtype = 'In Punch';
              else
                punchtype = "Out Punch";
            }
          });
        });
      }
    });
  }

  Future<bool> getNextPunchType(int superid, int regid) async {
    final String _url = Constants.apiUrl + "Employee/GetNextPunchType/" + superid.toString() + "/" + regid.toString();
    final response = await http.get(Uri.parse(_url));
    bool isInPunch = response.body.toString().toLowerCase() == 'true';

    return isInPunch;
  }

  Future<bool> processAttendance(int superid, int regid) async {
    final String _url = Constants.apiUrl + "Employee/GetProcessAttendance/" + superid.toString() + "/" + regid.toString();
    final response = await http.get(Uri.parse(_url));
    bool isInPunch = response.body.toString().toLowerCase() == 'true';

    return isInPunch;
  }

  Future<PunchResultModel> postAttendance(String superid, String regid, String lat, String long, String address, String notes) async {
    DateTime dt = new DateTime.now();
    String dot = dt.year.toString() + "-" + dt.month.toString() + "-" + dt.day.toString();
    String time = dt.hour.toString() + ":" + dt.minute.toString() + ":" + dt.second.toString();

    final String _url = Constants.apiUrl + 'Employee/PostGpsPunch';
    final punch = {
      "SuperId": superid,
      "RegistrationId": regid,
      "PunchDateTime": dot + " " + time,
      "Longitude": long,
      "Latitude": lat,
      "address": address,
      "notes": notes,
    };
    dynamic responseJson = {};
    try {
      print("kalyan" + punch.toString());
      final response = await http.post(Uri.parse(_url), body: punch);
      print("kalyan" + response.body.toString());
      responseJson = json.decode(response.body);
    } catch (e) {}
    return new PunchResultModel.fromJson(responseJson);
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

  void onPunchClicked() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (_currentPosition != null) {
        String _latitude = "";
        String _longitude = "";
        _latitude = _currentPosition!.latitude.toString();
        _longitude = _currentPosition!.longitude.toString();
        if (_currentPosition != null) {
          address = _currentAddress;
        }
        Future regFuture = verify(
          widget.superid.toString(),
          widget.regid.toString(),
          imagesBase64[0],
        );
        regFuture.then((value) {
          Future<Null> dialogFuture;
          if (value == null) {
            dialogFuture = _userDialog('Error Occured!', 'Retry');
          } else {
            if (value.data["Status"]) {
              Future<PunchResultModel> punchFuture =
                  postAttendance(widget.superid.toString(), widget.regid.toString(), _latitude, _longitude, address, _notesctrl.text);

              punchFuture.then((punchmap) {
                Future<Null> dialogFuture;
                if (punchmap == null) {
                  dialogFuture = _userDialog('Error Occured!', 'Retry');
                } else {
                  if (punchmap.result!) {
                    _notesctrl.text = "";
                    punchtype = "loading...";
                    setNextPunchType(widget.superid!, widget.regid!);
                    dialogFuture = _userDialog('Attendance Posted Successfully From ' + address, 'Ok');
                  } else {
                    dialogFuture = _userDialog(punchmap.errorMessage!, 'Retry');
                  }
                }

                dialogFuture.then((temp) {
                  setState(() {
                    isLoading = false;
                  });
                });
              });

              punchFuture.catchError(() {
                _userDialog('Unable to post attendance', 'Retry').then((temp) {
                  setState(() {
                    isLoading = false;
                  });
                });
              });
            } else {
              _userDialog('Location Not able to get. Make sure device GPS is on. Please relogin and try again.', 'Ok').then((temp) {
                setState(() {
                  isLoading = false;
                });
              });
            }
          }
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future verify(String superid, String personid, String imagesBase64) async {
    final String _url = Constants.imgApiUrl + 'personVeification_base64';
    final punch = {
      "superid": superid,
      "personid": personid,
      "image_data_base64": imagesBase64,
    };
    final response = await Dio().post(_url, data: punch);
    print("url" + response.statusCode.toString());
    print("response" + response.data.toString());
    return response;
  }

  @override
  Widget build(BuildContext context) {
    Widget buildLeaveSubmissionMenu() {
      if (widget.appType == "POR" || widget.appType == "STD") {
        return ListTile(
          title: new Text("Leave Submission"),
          trailing: new Icon(Icons.note),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new LeavePage(
                      regid: widget.regid,
                      superid: widget.superid,
                    )));
          },
        );
      } else {
        return Container();
      }
    }

    Widget buildNotesControl() {
      return Stack(
        children: [
          new TextFormField(
            decoration: InputDecoration(
              icon: Icon(Icons.note),
              hintText: "Notes",
              labelText: 'Notes',
            ),
            keyboardType: TextInputType.text,
            controller: _notesctrl,
          ),
        ],
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        title: new Text('Attendance'),
        actions: <Widget>[],
      ),
      body: isLoading
          ? new Center(
              child: new CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ))
          : new ListView(
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.all(20.0),
                  child: new Column(
                    children: <Widget>[
                      new Text(
                        'Welcome ' + widget.username!,
                        style: new TextStyle(fontSize: 25.0, color: Colors.grey),
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            height: 170,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _previewImageUrl == null
                                ? Text(
                                    'Loading...',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  )
                                : Image.network(
                                    _previewImageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Address:  $_currentAddress',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buildNotesControl(),
                      SizedBox(
                        height: 10,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new MaterialButton(
                            color: Colors.indigo,
                            textColor: Colors.white,
                            splashColor: Colors.black,
                            height: 40.0,
                            minWidth: 150.0,
                            child: new Text(punchtype, style: new TextStyle(fontSize: 15.0)),
                            onPressed: (() {
                              onPunchClicked();
                              Navigator.of(context).push(
                                new MaterialPageRoute(
                                  builder: (BuildContext context) => new AttendancePage(
                                      username: widget.username, superid: widget.superid, regid: widget.regid, emailid: widget.emailid),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: widgets != null ? widgets : <Widget>[Container()],
                )
              ],
            ),
    );
  }
}
