import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/screens/acceptRequest.dart';
import 'package:food_for_all/screens/comments.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ViewPost extends StatefulWidget {
  QueryDocumentSnapshot snapshot;

  ViewPost({this.snapshot});

  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  TextEditingController commentController = TextEditingController();
  DocumentSnapshot doc;
  List<dynamic> comments;
  DateTime postedAt;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    doc = widget.snapshot;
    Timestamp t = doc['createdAt'];
    setState(() {
      postedAt = t.toDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Hero(
            tag: widget.snapshot.id,
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Container(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                left: 30,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      widget.snapshot['photo'],
                                    ),
                                    radius: 30,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.snapshot['userName'],
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .selectedRowColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        DateFormat.yMMMd()
                                            .add_jm()
                                            .format(postedAt),
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      print("share");
                                      Share.share("Hey! Will you help this 😄",
                                          subject:
                                              "There is availability of ${widget.snapshot['foodQuantity']}Kg food from ${widget.snapshot['userName']}");
                                    },
                                    icon: Icon(
                                      Icons.share_rounded,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    tooltip: "Share this content",
                                  ),
                                ],
                              ),
                            ),
                            widget.snapshot['images']
                                ? Container(
                                    child: CarouselSlider.builder(
                                      itemCount: widget.snapshot['url'].length,
                                      itemBuilder:
                                          (context, index, realIndex) =>
                                              Container(
                                        child: Image.network(
                                          widget.snapshot['url'][index],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      options: CarouselOptions(
                                        aspectRatio: 1.0,
                                        enlargeCenterPage: true,
                                        autoPlay: true,
                                        viewportFraction: 0.7,
                                      ),
                                    ),
                                  )
                                : Text(""),
                            Container(
                              child: Text(
                                widget.snapshot['postContent'],
                                style: TextStyle(
                                  color: Theme.of(context).selectedRowColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                ),
                              ),
                              margin: EdgeInsets.only(
                                left: 25,
                                right: 25,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  widget.snapshot['postHeading'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Quantity",
                                    style: TextStyle(
                                      color: Theme.of(context).selectedRowColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    widget.snapshot['foodQuantity'].toString() +
                                        " Kg",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Number of persons can eat",
                                    style: TextStyle(
                                      color: Theme.of(context).selectedRowColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    widget.snapshot['nosPersons'].toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Expiry",
                                    style: TextStyle(
                                      color: Theme.of(context).selectedRowColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    widget.snapshot['expiry'].toString() +
                                        " Hrs",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Vessel count needed",
                                    style: TextStyle(
                                      color: Theme.of(context).selectedRowColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(
                                    widget.snapshot['vesselCount'].toString(),
                                    style: TextStyle(
                                      color: Theme.of(context).selectedRowColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Food type",
                                    style: TextStyle(
                                      color: Theme.of(context).selectedRowColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                (widget.snapshot['mainCourse'] &&
                                        widget.snapshot['tiffin'])
                                    ? Container(
                                        child: Text(
                                          "Main Course and Tiffin",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .selectedRowColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                        margin: EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                        ),
                                      )
                                    : widget.snapshot['mainCourse']
                                        ? Container(
                                            child: Text(
                                              "Main Course",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .selectedRowColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                              ),
                                            ),
                                            margin: EdgeInsets.only(
                                              left: 25,
                                              right: 25,
                                            ),
                                          )
                                        : widget.snapshot['tiffin']
                                            ? Container(
                                                child: Text(
                                                  "Tiffin",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .selectedRowColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                margin: EdgeInsets.only(
                                                  left: 25,
                                                  right: 25,
                                                ),
                                              )
                                            : Text("")
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                heroTag: "comment",
                icon: Icon(
                  Icons.comment,
                  color: Colors.white,
                ),
                label: Text(
                  "Comments",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Comments(
                        snapshot: widget.snapshot,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              FloatingActionButton.extended(
                heroTag: "accept",
                icon: Icon(
                  Icons.task_alt_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  "Accept",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onPressed: widget.snapshot['email'] ==
                        FirebaseAuth.instance.currentUser.email
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AcceptRequest(
                              snapshot: widget.snapshot,
                            ),
                          ),
                        );
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}
