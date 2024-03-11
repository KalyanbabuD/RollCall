import 'package:flutter/material.dart';
import 'pages/login.dart';
//import 'pages/test.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(),
      debugShowCheckedModeBanner: false,
      home: new LoginPage(),
    );
  }
}
