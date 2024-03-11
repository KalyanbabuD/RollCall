import 'package:av_smooth_star_rating/av_smooth_star_rating.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';

class AppRate extends StatelessWidget {
  final rateApp = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate this app'),
      ),
      body: buildRatingLayout(),
    );
  }

  Center buildRatingLayout() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/likeImage.jpg'),
            width: 280.0,
            height: 150.0,
          ),
          SmoothStarRating(
            rating: rateApp,
            size: 45,
            starCount: 5,
            spacing: 0.0,
            onRated: (value) {
              StoreRedirect.redirect(
                  androidAppId: "com.my.rollcallapp", iOSAppId: "7WKDT8D2DD");
              // setState(() {
              //   rateApp = value;
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
