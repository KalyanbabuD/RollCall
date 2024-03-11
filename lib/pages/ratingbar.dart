import 'package:av_smooth_star_rating/av_smooth_star_rating.dart';
import 'package:flutter/material.dart';

import 'attendance.dart';

class RatingBar extends StatefulWidget {
  const RatingBar({
    Key? key,
    this.username,
    this.regid,
    this.superid,
    this.emailid,
  }) : super(key: key);
  final String? username;
  final int? regid;
  final int? superid;
  final String? emailid;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  @override
  var rating = 4.5;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) => new AttendancePage(
                  regid: widget.regid,
                  emailid: widget.emailid,
                  superid: widget.superid,
                  username: widget.username,
                ),
              ),
            );
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.deepPurple, Colors.blue])),
        ),
        title: Text('Rate us'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rating',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            SmoothStarRating(
              rating: rating,
              size: 45,
              starCount: 5,
              onRated: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
