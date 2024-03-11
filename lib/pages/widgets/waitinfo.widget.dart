import 'package:flutter/material.dart';

class WeightInfoWidget extends StatelessWidget {
  final String status;
  WeightInfoWidget({Key? key,required this.status}):super(key:key);
  @override
  Widget build(BuildContext context) {
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
                  Text(this.status),
                ],
              ),
            ),
          ),
        ],
      );
  }
}