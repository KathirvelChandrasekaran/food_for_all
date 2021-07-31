import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoneyBagFirebase {
  MoneyBagFirebase();

  FirebaseAuth auth = FirebaseAuth.instance;

  void addMoneyBagDetails(
      BuildContext context, String title, description, upiID, int amount) {
    FirebaseFirestore.instance
        .collection('MoneyBag')
        .doc()
        .set({
      'email': auth.currentUser.email,
      'title': title,
      'description': description,
      'amount': amount,
      'credit': 0,
      'finished': false,
    }).then(
      (value) => Navigator.popUntil(
        context,
        (route) => route.isFirst,
      ),
    );
  }
}
