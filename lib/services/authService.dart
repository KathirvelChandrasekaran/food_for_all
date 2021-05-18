import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_all/screens/chooseRole.dart';
import 'package:food_for_all/screens/newsFeed.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChange => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    userCredential.additionalUserInfo.isNewUser
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChooseRole(),
            ),
          )
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NewsFeed(),
            ),
          );
    return userCredential;
  }
}
