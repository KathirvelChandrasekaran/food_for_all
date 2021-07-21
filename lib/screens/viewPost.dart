import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/services/createPostService.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
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

  @override
  void initState() {
    super.initState();
    doc = widget.snapshot;
    print(doc['comments'][0]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Scaffold(
          appBar: AppBar(),
          body: SlidingUpPanel(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            backdropEnabled: true,
            maxHeight: MediaQuery.of(context).size.height * 0.75,
            panel: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
              },
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.maximize_rounded,
                        size: 50,
                        color: Colors.grey,
                      ),
                      Text(
                        "Comments",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).selectedRowColor,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.snapshot['photo'],
                            ),
                            radius: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextFormField(
                              controller: commentController,
                              keyboardType: TextInputType.text,
                              cursorColor: Theme.of(context).accentColor,
                              onChanged: (data) {},
                              decoration: InputDecoration(
                                labelText: "Post your comment",
                                labelStyle: TextStyle(
                                  color: Theme.of(context).selectedRowColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      20.0,
                                    ),
                                  ),
                                  borderSide: BorderSide(width: 2.5),
                                ),
                                suffixIcon: IconButton(
                                  tooltip: "Post your comment",
                                  onPressed: () {
                                    AddPostDetailsToFirebase().addCommentToPost(
                                        widget.snapshot,
                                        commentController.text);
                                  },
                                  icon: Icon(
                                    Icons.send_rounded,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    25.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Divider(
                          thickness: 2.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      widget.snapshot['comments'].length == 0
                          ? Text(
                              "No comments yet !😅",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).selectedRowColor,
                                fontSize: 22,
                              ),
                            )
                          : Text(widget.snapshot['comments'][0]['commentedBy'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).selectedRowColor,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                            widget.snapshot['createdAt']
                                                .toDate(),
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
                                        itemCount:
                                            widget.snapshot['url'].length,
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
                                        color:
                                            Theme.of(context).selectedRowColor,
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
                                      widget.snapshot['foodQuantity']
                                              .toString() +
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
                                        color:
                                            Theme.of(context).selectedRowColor,
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
                                        color:
                                            Theme.of(context).selectedRowColor,
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
                                        color:
                                            Theme.of(context).selectedRowColor,
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
                                        color:
                                            Theme.of(context).selectedRowColor,
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
                                        color:
                                            Theme.of(context).selectedRowColor,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
