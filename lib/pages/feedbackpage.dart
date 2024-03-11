import 'package:av_smooth_star_rating/av_smooth_star_rating.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedBack extends StatelessWidget {
  
  final rateService = 5.0;

  _launchURL() async {
    const url =
        'https://www.google.com/search?q=perennial+code&oq=perennial+code&aqs=chrome..69i57j69i60l2j69i65j69i61.3321j0j7&sourceid=chrome&ie=UTF-8';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Give Us Rate'),
        ),
        body: buildRateLayout());
  }

  Widget buildRateLayout() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/service.jpg'),
            width: 280.0,
            height: 150.0,
          ),
          SmoothStarRating(
            rating: rateService,
            size: 45,
            starCount: 5,
            spacing: 2.0,
            onRated: (value) {
              _launchURL();
              // setState(() {
              //   rateService = value;
              // });
            },
          ),
          Text(
            'Please give us rate & feedback.',
            style: TextStyle(color: Colors.blueAccent, fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
