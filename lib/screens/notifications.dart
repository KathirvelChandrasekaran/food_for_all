import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Notifications")
            .doc(FirebaseAuth.instance.currentUser.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Map<String, dynamic> fetchedNotifications =
              new Map<String, dynamic>.from(snapshot.data.data());
          if ((snapshot.connectionState == ConnectionState.waiting) ||
              (!snapshot.hasData))
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          if (fetchedNotifications['notifications'].length < 1)
            return Center(
              child: Text(
                "No comments found ☹️",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
            );
          return ListView(
            shrinkWrap: true,
            primary: true,
            scrollDirection: Axis.vertical,
            children: [
              for (var i = 0;
                  i < fetchedNotifications['notifications'].length;
                  i++)
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            fetchedNotifications['notifications'][i]['body'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25.0),
                          child: Text(
                            timeago.format(
                              fetchedNotifications['notifications'][i]
                                      ['createdAt']
                                  .toDate(),
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
