import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/createPostProvider.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:logger/logger.dart';
// import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class AcceptRequest extends StatefulWidget {
  QueryDocumentSnapshot snapshot;

  AcceptRequest({this.snapshot});

  @override
  _AcceptRequestState createState() => _AcceptRequestState();
}

class _AcceptRequestState extends State<AcceptRequest> {
  DocumentSnapshot doc, userDoc;
  double lat;
  double lng;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    doc = widget.snapshot;
  }

  // _launchURL(String gMaps) async {
  //   await canLaunch(gMaps) ? await launch(gMaps) : throw "could not launch URL";
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final updatePost = watch(addPostDetails);

        final theme = watch(themingNotifer);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Accept Request",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Image.asset(
                    'images/AcceptRequest.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     FirebaseFirestore.instance
                //         .collection("UserDetails")
                //         .where('email', isEqualTo: widget.snapshot['email'])
                //         .get()
                //         .then((value) {
                //       logger.i(value.docs[0].data()['latitude']);
                //       _launchURL(
                //         "google.navigation:q=${value.docs[0].data()['latitude']},${value.docs[0].data()['longitude']}",
                //       );
                //     });
                //   },
                //   style: ElevatedButton.styleFrom(
                //     primary: Theme.of(context).primaryColor,
                //     padding:
                //         EdgeInsets.symmetric(vertical: 15, horizontal: 110),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //   ),
                //   child: Text(
                //     "View direction",
                //     style: TextStyle(
                //       fontSize: 20,
                //       color: theme.darkTheme ? Colors.white : Colors.black,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                ElevatedButton(
                  onPressed: () {
                    updatePost.acceptRequest(widget.snapshot);
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Accept Request",
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.darkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
