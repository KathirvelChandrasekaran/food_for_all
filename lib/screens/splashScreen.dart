import 'package:flutter/material.dart';
import 'package:food_for_all/app.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class AppSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        navigateRoute: App(),
        duration: 3000,
        imageSize: 130,
        imageSrc: "assets/images/Donate.png",
        backgroundColor: Colors.white,
      ),
    );
  }
}
