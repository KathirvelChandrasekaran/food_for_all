import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPostDetailsToFirebase {
  AddPostDetailsToFirebase();

  addPostDetails(
    BuildContext context,
    double foodQuantity,
    expiry,
    String postHeading,
    postContent,
    int nosPersons,
    vesselCount,
    bool needVessel,
    tiffin,
    mainCourse,
    imageUpload,
  ) {
    FirebaseFirestore.instance
        .collection("Posts")
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('Post')
        .add({
      'foodQuantity': foodQuantity,
      'expiry': expiry,
      'postHeading': postHeading,
      'postContent': postContent,
      'nosPersons': nosPersons,
      'vesselCount': vesselCount,
      'needVessel': needVessel,
      'tiffin': tiffin,
      'mainCourse': mainCourse,
      'images': imageUpload,
    }).whenComplete(
      () => Navigator.popAndPushNamed(context, '/postSuccess'),
    );
  }
}
