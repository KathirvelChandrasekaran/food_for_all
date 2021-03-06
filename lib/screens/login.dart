import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:food_for_all/providers/authServiceProvider.dart';

class Login extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _auth = watch(authServiceProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Image.asset(
                  'images/Login.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
              ),
            ),
            SignInButton(
              Buttons.Google,
              text: "Continue with Google",
              elevation: 5,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                top: MediaQuery.of(context).size.height * 0.01,
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(
                  30.0,
                ),
              ),
              onPressed: () {
                _auth.signInWithGoogle(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
