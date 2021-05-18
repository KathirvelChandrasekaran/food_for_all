// ignore: non_constant_identifier_names
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
ElevatedButton RoundedButton(BuildContext context, String btnText, double h, double v, Widget page) {
  return ElevatedButton(
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
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

ElevatedButton RoundedPushButton(BuildContext context, String btnText, double h, double v, Widget page, Color bgColor, Color txtColor) {
  return ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      primary: bgColor,
      padding: EdgeInsets.symmetric(vertical: h, horizontal: v),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    ),
    child: Text(
      btnText,
      style: TextStyle(
        fontSize: 20,
        color: txtColor
      ),
    ),
  );
}

