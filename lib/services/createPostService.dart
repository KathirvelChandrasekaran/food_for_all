import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_for_all/utils/algoliaManager.dart';

class AddPostDetailsToFirebase {
  AddPostDetailsToFirebase();

  User _auth = FirebaseAuth.instance.currentUser;

  Future<void> addPostDetails(
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
  ) async {
    var algolia = AlgoliaManager.algolia;
    await algolia.instance.index("posts").addObject({
      'foodQuantity': foodQuantity,
      'expiry': expiry,
      'postHeading': postHeading,
      'postContent': postContent,
      'nosPersons': nosPersons,
      'vesselCount': vesselCount,
      'needVessel': needVessel,
      'tiffin': tiffin,
      'mainCourse': mainCourse,
      'email': _auth.email,
      'userName': _auth.displayName,
      'photo': _auth.photoURL,
      'createdAt': DateTime.now(),
      "accepted": false,
    });
    FirebaseFirestore.instance
        .collection("Posts")
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
          'email': _auth.email,
          'userName': _auth.displayName,
          'photo': _auth.photoURL,
          'createdAt': DateTime.now(),
          "comments": FieldValue.arrayUnion([{}]),
          "accepted": false,
        })
        .then(
          (value) => {
            FirebaseFirestore.instance
                .collection('PostQuantity')
                .doc(_auth.email)
                .get()
                .then(
                  (value) => {
                    FirebaseFirestore.instance
                        .collection("PostQuantity")
                        .doc(_auth.email)
                        .update({
                      'foodQuantity':
                          value.data()["foodQuantity"] + foodQuantity.toInt(),
                      'nosPersons':
                          value.data()["nosPersons"] + nosPersons.toInt(),
                    })
                  },
                ),
          },
        )
        .whenComplete(
          () => Navigator.popAndPushNamed(context, '/postSuccess'),
        );
  }

  addCommentToPost(QueryDocumentSnapshot snapshot, String comment) {
    FirebaseFirestore.instance.collection("Posts").doc(snapshot.id).update({
      'comments': FieldValue.arrayUnion([
        {
          'comment': comment,
          'commentedBy': _auth.displayName,
          'commentedAt': DateTime.now(),
          'commentedPhotoURL': _auth.photoURL,
        }
      ])
    });
  }

  acceptRequest(QueryDocumentSnapshot snapshot) {
    FirebaseFirestore.instance.collection("Posts").doc(snapshot.id).update({
      'accepted': true,
    });
  }
}
