import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_all/screens/newsFeed.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisterDetailsToFirebase {
  RegisterDetailsToFirebase();

  void addRegisterDetails(
      BuildContext context, String address, LatLng latLng, int phone) {
    FirebaseFirestore.instance
        .collection("UserDetails")
        .doc(FirebaseAuth.instance.currentUser.email)
        .set({
      'address': address,
      'mobile': phone,
      'latitude': latLng.latitude,
      'longitude': latLng.longitude
    }).then(
      (value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewsFeed(),
        ),
      ),
    );
  }
}
