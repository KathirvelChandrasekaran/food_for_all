import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/registerDetailsProvider.dart';
import 'package:food_for_all/screens/home.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:pinput/pin_put/pin_put.dart';

// ignore: must_be_immutable
class OTP extends StatefulWidget {
  String phone;
  OTP({this.phone});

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String _verificationCode;
  var data;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );

  void createSnackBar(String message) {
    final snackBar = new SnackBar(
      content: new Text(message),
      backgroundColor: Theme.of(context).errorColor,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        FirebaseAuth.instance.currentUser
            .linkWithPhoneNumber(widget.phone)
            .then((value) => value.confirm(_verificationCode));
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verficationID, int resendToken) {
        setState(() {
          _verificationCode = verficationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: Duration(seconds: 120),
    );
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final phone = watch(registerProvider).phone;
      final theme = watch(themingNotifer);

      return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  'Verify $phone',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: PinPut(
                fieldsCount: 6,
                textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                eachFieldWidth: 40.0,
                eachFieldHeight: 55.0,
                focusNode: _pinPutFocusNode,
                controller: _pinPutController,
                submittedFieldDecoration: pinPutDecoration,
                selectedFieldDecoration: pinPutDecoration,
                followingFieldDecoration: pinPutDecoration,
                pinAnimationType: PinAnimationType.fade,
                onSubmit: (pin) async {
                  try {
                    // await FirebaseAuth.instance
                    //     .signInWithCredential(PhoneAuthProvider.credential(
                    //         verificationId: _verificationCode, smsCode: pin))
                    // await FirebaseAuth.instance.currentUser
                    //     .linkWithPhoneNumber(widget.phone)
                    //     .then((value) => value.confirm(pin))

                    // data.then((value) async {
                    //   if (value.user != null) {
                    //     Navigator.pushAndRemoveUntil(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => Home()),
                    //         (route) => false);
                    //   }
                    // });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                        (route) => false);
                  } catch (e) {
                    FocusScope.of(context).unfocus();
                    createSnackBar("Invalid OTP");
                  }
                },
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                _verifyPhone();
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 125),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Resend",
                style: TextStyle(
                  fontSize: 20,
                  color: theme.darkTheme ? Colors.white : Colors.black,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
