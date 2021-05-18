import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
            ),
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              Navigator.popAndPushNamed(
                context,
                '/wrapper',
              );
            },
          )
        ],
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
            RoundedButton(context, 'School / College', 15, 100),
            SizedBox(height: 15,),
            RoundedButton(context, 'NGO', 15, 155),
            SizedBox(height: 15,),
            RoundedButton(context, 'Volunteer', 15, 130),
            SizedBox(height: 15,),
            RoundedButton(context, 'General User', 15, 115),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  ElevatedButton RoundedButton(BuildContext context, String btnText, double h, double v) {
    return ElevatedButton(
      onPressed: () {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Login(),
        //   ),
        // );
      },
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).accentColor,
        padding: EdgeInsets.symmetric(vertical: h, horizontal: v),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Text(
        btnText,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
