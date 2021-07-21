import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/screens/home.dart';
import 'package:food_for_all/screens/postSuccess.dart';
import 'package:food_for_all/screens/splashScreen.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:food_for_all/utils/wrapper.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Color(0xFF7AB317),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light),
    );
    return Consumer(
      builder: (context, watch, child) {
        final themingConsumer = watch(themingNotifer);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: !themingConsumer.darkTheme ? darkTheme : lightTheme,
          routes: {
            '/wrapper': (context) => Wrapper(),
            '/home': (context) => Home(),
            '/postSuccess': (context) => PostSuccess(),
          },
          home: AppSplashScreen(),
        );
      },
    );
  }
}
