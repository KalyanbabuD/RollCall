import 'dart:io';
import 'package:flutter/material.dart' show AlertDialog, BoxDecoration, BoxShadow, BoxShape, BuildContext, Center, CircularProgressIndicator, Colors, Column, Container, CrossAxisAlignment, EdgeInsets, FlatButton, ListBody, MainAxisAlignment, ModalBarrier, Navigator, Offset, Opacity, SingleChildScrollView, SizedBox, Stack, Text, TextButton, Widget, showDialog;

class CommonUtil {
  static String toyyyyMMdd(DateTime date){  
    //String result = date.year.toString() + "-" + date.month.toString() + "-" + date.day.toString();
    String result = date.toIso8601String().substring(0,10);
    return result;
}

 static List<Map<String, dynamic>> getListOfMaps(List<dynamic> dynamicList) {
    return dynamicList
        .cast<Map<String, dynamic>>()
        .map((trace) => trace.cast<String, dynamic>())
        .toList();
  }

static String toyyyyMMddHHMM(DateTime date){      
    String result = '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}';
    return result;
}

static String toddMMyyyy(DateTime date){  
    String result = date.day.toString() + "-" + date.month.toString() + "-" +  date.year.toString();   
    return result;
}


  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print(result);
      if (result != null &&
          result[0].rawAddress.isNotEmpty &&
          result[0].rawAddress.isNotEmpty) {
        return true;
      }
      else{
        return false;
      }
    } on SocketException catch (_) {      
      return false;
    }
  }  

  static Future<void> showAlertDialog(BuildContext context, bool barrierDismissible,
    String headerText, String bodyText, String actionText) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(headerText),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(bodyText),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}



Widget loaderWidget(String statusText){
  return Stack(
        children: [
          new Opacity(
            opacity: 0.5,
            
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: Container(            
              decoration: new BoxDecoration(
              //border: new Border.all(width: 1.0, color: Colors.grey),
              shape: BoxShape.rectangle,
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 6.0),
                  blurRadius: 10.0,
                ),
              ],
            ),
              margin: EdgeInsets.all(10.0),                         
              height: 150,
              width: double.infinity,
              child: Column(            
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  CircularProgressIndicator(),
                  SizedBox(height: 20.0,),
                  Text(statusText),
                ],
              ),
            ),
          ),
        ],
      );
}

enum appTypes{
  IND,
  POR,
  STD,
  PRE
}
