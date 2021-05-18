import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_all/screens/registerDetails.dart';
import 'package:food_for_all/widgets/buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose your role",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'images/Role.png',
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.5,
              ),
            ),
            RoundedButton(
              context,
              'School / College',
              15,
              100,
              RegisterDetails(),
            ),
            SizedBox(
              height: 15,
            ),
            RoundedButton(
              context,
              'NGO',
              15,
              155,
              RegisterDetails(),
            ),
            SizedBox(
              height: 15,
            ),
            RoundedButton(
              context,
              'Volunteer',
              15,
              130,
              RegisterDetails(),
            ),
            SizedBox(
              height: 15,
            ),
            RoundedButton(
              context,
              'General User',
              15,
              115,
              RegisterDetails(),
            ),
          ],
        ),
      ),
    );
  }
}
