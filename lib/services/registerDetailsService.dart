import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_for_all/screens/home.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisterDetailsToFirebase {
  RegisterDetailsToFirebase();

  void addRegisterDetails(BuildContext context, String address, LatLng latLng,
      int phone, String role, String orgName) {
    FirebaseFirestore.instance
        .collection("UserDetails")
        .doc(FirebaseAuth.instance.currentUser.email)
        .set({
          'address': address,
          'mobile': phone,
          'latitude': latLng.latitude,
          'longitude': latLng.longitude,
          'role': role,
          'orgName': orgName == "" ? "" : orgName,
          'email': FirebaseAuth.instance.currentUser.email,
        })
        .then((value) => {
              FirebaseFirestore.instance
                  .collection("PostQuantity")
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .set({
                'foodQuantity': 0,
                'nosPersons': 0,
                'email': FirebaseAuth.instance.currentUser.email,
              })
            })
        .then(
          // (value) => Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OTP(
          //       phone: phone.toString(),
          //     ),
          //   ),
          // ),
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          ),
        );
  }

  void editRegisterDetails(
      BuildContext context, String address, LatLng latLng, int phone) {
    FirebaseFirestore.instance
        .collection("UserDetails")
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({
      'address': address,
      'mobile': phone,
      'latitude': latLng.latitude,
      'longitude': latLng.longitude
    }).then(
      (value) => Navigator.pop(
        context,
      ),
    );
  }

  Stream<DocumentSnapshot> viewUserDetails() {
    var snapShot = FirebaseFirestore.instance
        .collection('UserDetails')
        .doc(FirebaseAuth.instance.currentUser.email)
        .snapshots();
    return snapShot;
  }
}
