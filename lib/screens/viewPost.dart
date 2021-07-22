import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/screens/comments.dart';
import 'package:logger/logger.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

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

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    doc = widget.snapshot;
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
                  Flexible(
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
                                        timeago.format(
                                          widget.snapshot['createdAt'].toDate(),
                                        ),
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
                                    onPressed: () {},
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
          floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.comment,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Comments(snapshot: widget.snapshot,),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
