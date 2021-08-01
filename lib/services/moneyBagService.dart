import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoneyBagFirebase {
  MoneyBagFirebase();

  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference db = FirebaseFirestore.instance.collection('MoneyBag');

  void addMoneyBagDetails(
      BuildContext context, String title, description, upiID, int amount) {
    db.doc().set({
      'email': auth.currentUser.email,
      'title': title,
      'description': description,
      'name': auth.currentUser.displayName,
      'url': auth.currentUser.photoURL,
      'createdAt': DateTime.now(),
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

  Stream<QuerySnapshot> getPendingMoneyBag() {
    var snapshot = db
        .where('email', isEqualTo: auth.currentUser.email)
        .where('finished', isEqualTo: false)
        .snapshots();
    return snapshot;
  }
}
