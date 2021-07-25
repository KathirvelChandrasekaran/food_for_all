import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_for_all/utils/wrapper.dart';

class AppSplashScreen extends StatefulWidget {
  @override
  _AppSplashScreenState createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Wrapper(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Image.asset(
                'images/Donate.png',
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Food",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              Text(
                "for All",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
