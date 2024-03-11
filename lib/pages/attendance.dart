import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rollcallapp/Helper/location_helper.dart';
import 'package:rollcallapp/models/registerImage.dart';
import 'package:rollcallapp/pages/leave.dart';
import 'package:rollcallapp/pages/mapviewpage.dart';
import 'package:rollcallapp/pages/ratingbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/addressmodel.dart';
import '../models/attendancemodel.dart';
import '../models/punchresultmodel.dart';
import '../models/constants.dart';
import '../pages/dayinout.dart';
import '../pages/login.dart';
import '../pages/changepassword.dart';
import '../pages/profile.dart';
import 'leavesummary.dart';
import 'package:image_picker/image_picker.dart';

class AttendancePage extends StatefulWidget {
  final String? username;
  final int? regid;
  final int? superid;
  final String? emailid;
  final String? appType;

  AttendancePage({Key? key, this.username, this.regid, this.superid, this.emailid, this.appType}) : super(key: key);

  @override
  AttendancePageState createState() => new AttendancePageState();
}

class AttendancePageState extends State<AttendancePage> {
  bool isLoading = false;
  String? address;
  File? cameraFile;
  String punchtype = 'loading..';
  TextEditingController _notesctrl = new TextEditingController();
  String? error;
  List<Widget> widgets = [];
  String? _currentAddress;
  Position? _currentPosition;
  bool currentWidget = true;
  final ImagePicker _picker = ImagePicker();
  File? imageFile;
  List images = [];
  List imagesBase64 = [];
  List imagesNames = [];

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    setNextPunchType(widget.superid!, widget.regid!);
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
      final response = await http.post(Uri.parse(_url), body: punch);

      responseJson = json.decode(response.body);
    } catch (e) {}
    return new PunchResultModel.fromJson(responseJson);
  }

  Future<RegisterImageModel> postResister(String superid, String personid, String imagesBase64) async {
    final String _url = Constants.apiUrl + 'personRegistration_base64';
    final punch = {
      "superid": superid,
      "personid": personid,
      "image_data_base64": imagesBase64,
    };
    dynamic responseJson = {};
    try {
      final response = await http.post(Uri.parse(_url), body: punch);

      responseJson = json.decode(response.body);
    } catch (e) {}
    return new RegisterImageModel.fromJson(responseJson);
  }

  capturedCamImages() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    try {
      String base64String = convertImageFileToBase64String(imageFile!);
      debugPrint(imagesNames.length.toString());
      setState(() {
        images.add(imageFile!);
        imagesNames.add(pickedFile!.name);
        imagesBase64.add(base64String);
        setState(() {
          images;
        });
      });
      if(imagesBase64.isNotEmpty){
        onRegister();
      }
    } catch (e) {
      // showError(e);
    }
  }

  String convertImageFileToBase64String(File imageFile) {
    String base64Image = "";
    Uint8List? bytesCond;
    bytesCond = File(imageFile.path).readAsBytesSync();
    base64Image = base64Encode(bytesCond);
    return base64Image;
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
      ),
    );
  }

  void onPunchClicked() async {
    setState(
      () {
        isLoading = true;
      },
    );

    try {
      if (_currentPosition != null) {
        String _latitude = "";
        String _longitude = "";
        _latitude = _currentPosition!.latitude.toString();
        _longitude = _currentPosition!.longitude.toString();

        if (_currentPosition != null) {
          address = _currentAddress;
        }

        Future<PunchResultModel> punchFuture =
            postAttendance(widget.superid.toString(), widget.regid.toString(), _latitude, _longitude, address!, _notesctrl.text);

        punchFuture.then((punchmap) {
          Future<Null> dialogFuture;
          if (punchmap == null) {
            dialogFuture = _userDialog('Error Occured!', 'Retry');
          } else {
            if (punchmap.result) {
              _notesctrl.text = "";
              punchtype = "loading...";
              setNextPunchType(widget.superid!, widget.regid!);
              dialogFuture = _userDialog('Attendance Posted Successfully From ' + address!, 'Ok');
            } else {
              dialogFuture = _userDialog(punchmap.errorMessage, 'Retry');
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  onRegister() {
    Future<RegisterImageModel> regFuture = postResister(
      widget.superid.toString(),
      widget.regid.toString(),
      imagesBase64[0],
    );
    regFuture.then((value) {
      Future<Null> dialogFuture;
      if (value == null) {
        dialogFuture = _userDialog('Error Occured!', 'Retry');
      } else {
        if (value.status) {
          dialogFuture = _userDialog('Registered  Successfully From ' + address!, 'Ok');
        } else {
          dialogFuture = _userDialog(value.message, 'Retry');
        }
      }
    });
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
                      regid: widget.regid!,
                      superid: widget.superid!,
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
              suffixIcon: InkWell(
                child: Icon(Icons.pin_drop),
                onTap: () {
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new MapViewPage(username: widget.username!, superid: widget.superid!, regid: widget.regid!, emailid: widget.emailid!),
                    ),
                  );
                },
              ),
            ),
            keyboardType: TextInputType.text,
            controller: _notesctrl,
          ),
        ],
      );
    }

    Future<List<AttendanceModel>> getAttendance(int regid, String superid) async {
      final String url = Constants.apiUrl + "Employee/getempattendance?SuperId=" + superid + "&RegistrationId=" + regid.toString();
      //print(url);
      final response = await http.get(Uri.parse(url));
      final responsejson = json.decode(response.body);
      List<AttendanceModel> atts = <AttendanceModel>[];
      for (var attjson in responsejson) {
        atts.add(new AttendanceModel.fromJson(attjson));
      }
      return atts;
    }

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigo,
        title: new Text('Attendance'),
        actions: <Widget>[IconButton(onPressed: () {
          capturedCamImages();
        }, icon: Icon(Icons.person_add_alt_1))],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            InkWell(
              child: new UserAccountsDrawerHeader(
                accountEmail: new Text(widget.emailid!),
                accountName: new Text(
                  widget.username!,
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentAccountPicture: new GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: new Text(
                      widget.username.toString().substring(0, 1),
                      style: new TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                decoration: new BoxDecoration(
                  image: new DecorationImage(image: new AssetImage('images/backgroundimage.png'), fit: BoxFit.fill),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (BuildContext context) => new ProfilePage(
                      regid: widget.regid!,
                      superid: widget.superid!,
                    ),
                  ),
                );
              },
            ),
            new ExpansionTile(
              title: Text("Submit"),
              leading: Icon(Icons.feed_outlined), //add icon
              childrenPadding: EdgeInsets.only(left: 60), //children padding
              children: [
                buildLeaveSubmissionMenu(),
                ListTile(
                  title: new Text("Leave Summary"),
                  trailing: new Icon(Icons.list_alt),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new LeaveSummaryPage(
                            username: widget.username!, superid: widget.superid!, regid: widget.regid!, emailid: widget.emailid!)));
                  },
                ),
              ],
            ),
            new ExpansionTile(
              title: Text("Reports"),
              leading: Icon(Icons.file_copy), //add icon
              childrenPadding: EdgeInsets.only(left: 60), //children padding
              children: [
                ListTile(
                  title: new Text("Attendance Report"),
                  trailing: new Icon(Icons.alarm),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (BuildContext context) => new DayInoutPage(
                          regid: widget.regid!,
                          emailid: widget.emailid!,
                          superid: widget.superid!,
                          username: widget.username!,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            new ListTile(
              title: new Text("Change Password"),
              trailing: new Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new ChangePwdPage(
                          regid: widget.regid!,
                          superid: widget.superid!,
                        )));
              },
            ),
            Divider(),
            new ListTile(
              title: new Text("Rate Us"),
              trailing: new Icon(Icons.star),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new RatingBar(
                              regid: widget.regid!,
                              emailid: widget.emailid!,
                              superid: widget.superid!,
                              username: widget.username!,
                            )),
                    (Route<dynamic> route) => false);
              },
            ),
            new ListTile(
              title: new Text("Feedback"),
              trailing: new Icon(Icons.settings),
              onTap: () {
                LaunchReview.launch(androidAppId: "com.my.rollcallapp");
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("Log Out"),
              trailing: new Icon(Icons.exit_to_app),
              onTap: () async {
                final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.remove('userId');
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()), (Route<dynamic> route) => false);
              },
            ),
            new Container(
              child: new Image.asset('images/rc_logo.png'),
            ),
          ],
        ),
      ),
      body: isLoading
          ? new Center(
              child: new CircularProgressIndicator(),
            )
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
                      buildNotesControl(),
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
                            onPressed: onPunchClicked,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        'Last Punches',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Card(
                        child: SizedBox(
                          width: 450,
                          height: 400,
                          child: Center(
                            child: new FutureBuilder<List<AttendanceModel>>(
                              future: getAttendance(widget.regid!, widget.superid.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return new ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return new Card(
                                        child: new Container(
                                          padding: const EdgeInsets.all(15.0),
                                          child: new Row(
                                            children: <Widget>[
                                              new CircleAvatar(
                                                backgroundColor: Colors.indigo,
                                                child: new Text(snapshot.data!.elementAt(index).dateOfTransaction!.day.toString()),
                                              ),
                                              new Padding(
                                                padding: const EdgeInsets.only(right: 15.0),
                                              ),
                                              new Column(
                                                children: <Widget>[
                                                  new Text(
                                                    snapshot.data!.elementAt(index).dateOfTransaction!.day.toString() +
                                                        "-" +
                                                        snapshot.data!.elementAt(index).dateOfTransaction!.month.toString() +
                                                        "-" +
                                                        snapshot.data!.elementAt(index).dateOfTransaction!.year.toString(),
                                                    style: new TextStyle(
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  new Padding(padding: const EdgeInsets.only(bottom: 5.0)),
                                                  new Row(
                                                    children: <Widget>[
                                                      new Text('In: ' + snapshot.data!.elementAt(index).inTime.toString()),
                                                      new Padding(
                                                        padding: const EdgeInsets.only(right: 5.0),
                                                      ),
                                                      new Text('Out: ' + snapshot.data!.elementAt(index).outTime)
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
                          ),
                        ),
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
