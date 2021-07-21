import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:food_for_all/screens/starter.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final theme = watch(themingNotifer);

        return Scaffold(
          body: Container(
            child: IntroductionScreen(
              done: Text(
                'Done',
                style: TextStyle(
                  color: theme.darkTheme ? Colors.white : Theme.of(context).primaryColor,
                ),
              ),
              onDone: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Starter(),
                  ),
                );
              },
              pages: getPages(),
              showNextButton: false,
              dotsDecorator: const DotsDecorator(
                size: Size(10.0, 10.0),
                color: Color(0xFF7AB317),
                activeSize: Size(22.0, 10.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
                activeColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  var pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyTextStyle: TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    imagePadding: EdgeInsets.all(50),
  );

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset(
          'images/HelpIntro_1.png',
          fit: BoxFit.contain,
        ),
        title: "Share your things and thoughts",
        body: "To be included",
        decoration: pageDecoration,
      ),
      PageViewModel(
        image: Image.asset(
          'images/HelpIntro2.png',
          fit: BoxFit.contain,
        ),
        title: "Share your things and thoughts",
        body: "To be included",
        decoration: pageDecoration,
      ),
      PageViewModel(
        image: Image.asset(
          'images/ChooseTheme.png',
        ),
        title: "Choose your theme",
        body: "Light / Dark",
        footer: Consumer(
          builder: (context, watch, child) {
            final themingListener = watch(themingNotifer);
            return FlutterSwitch(
              width: 100.0,
              height: 50.0,
              toggleSize: 50.0,
              value: themingListener.darkTheme,
              borderRadius: 50.0,
              activeToggleColor: Colors.black,
              inactiveToggleColor: Colors.white,
              activeSwitchBorder: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
              inactiveSwitchBorder: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2.0,
              ),
              activeColor: Theme.of(context).scaffoldBackgroundColor,
              inactiveColor: Theme.of(context).scaffoldBackgroundColor,
              activeIcon: Image.asset(
                "images/sun.png",
                height: 500,
              ),
              inactiveIcon: Image.asset(
                "images/moon.png",
              ),
              onToggle: (val) {
                setState(() {
                  themingListener.toggleTheme();
                });
              },
            );
          },
        ),
        decoration: pageDecoration,
      ),
    ];
  }
}
