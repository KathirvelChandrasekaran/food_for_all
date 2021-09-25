import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/newsFeedProvider.dart';
import 'package:food_for_all/screens/viewPost.dart';
import 'package:timeago/timeago.dart' as timeago;

class VolunteerPosts extends StatefulWidget {
  @override
  _VolunteerPostsState createState() => _VolunteerPostsState();
}

class _VolunteerPostsState extends State<VolunteerPosts> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final volunteerPost = watch(getVolunteerPosts.stream);
        return Scaffold(
          appBar: AppBar(),
          body: StreamBuilder(
            stream: volunteerPost,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              if (snapshot.data.size < 1)
                return Center(
                  child: Text(
                    "No post found ☹️",
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
                children: snapshot.data.docs.map(
                  (doc) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: BouncingWidget(
                            scaleFactor: 0.5,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewPost(
                                    snapshot: doc,
                                    acceptRequest: false,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: doc.id,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 20,
                                        top: 30,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              doc['photo'],
                                            ),
                                            radius: 30,
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                doc['userName'],
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .selectedRowColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                timeago.format(
                                                  doc['createdAt'].toDate(),
                                                ),
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .selectedRowColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    doc['images']
                                        ? Container(
                                            child: CarouselSlider.builder(
                                              itemCount: doc['url'].length,
                                              itemBuilder:
                                                  (context, index, realIndex) =>
                                                      Container(
                                                child: Image.network(
                                                  doc['url'][index],
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: Text(
                                        doc['postContent'],
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .selectedRowColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
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
                                        doc['postHeading'],
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .selectedRowColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      margin: EdgeInsets.only(
                                        left: 25,
                                        right: 25,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ).toList(),
              );
            },
          ),
        );
      },
    );
  }
}
