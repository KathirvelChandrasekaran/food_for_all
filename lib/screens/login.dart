import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:food_for_all/providers/authServiceProvider.dart';

class Login extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _auth = watch(authServiceProvider);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SvgPicture.asset(
                  'images/Login.svg',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.6,
                ),
              ),
            ),
            SignInButton(
              Buttons.Google,
              text: "Continue with Google",
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
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
