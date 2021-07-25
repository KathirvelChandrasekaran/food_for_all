import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/authServiceProvider.dart';
import 'package:food_for_all/providers/newsFeedProvider.dart';
import 'package:food_for_all/screens/createPost.dart';
import 'package:food_for_all/screens/profile.dart';
import 'package:food_for_all/screens/viewPost.dart';
import 'package:food_for_all/screens/volunteerPosts.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  String role = "";

  @override
  void initState() {
    super.initState();
    getRole();
  }

  Future<void> getRole() async {
    await FirebaseFirestore.instance
        .collection('UserDetails')
        .doc(FirebaseAuth.instance.currentUser.email)
        .snapshots()
        .listen((event) {
      setState(() {
        role = event.get('role');
      });
      print(role);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final _authService = watch(firebaseAuthProvider).currentUser;
        final posts = watch(getNewsFeeds.stream);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Food for All",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(
                        userCredential: _authService,
                      ),
                    ),
                  );
                },
                child: Tooltip(
                  message: "Profile",
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 30,
                    ),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 27,
                      child: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        radius: 25,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            _authService.photoURL.toString(),
                          ),
                          radius: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 30,
                ),
                child: Text(
                  "Create a Post",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 30,
                ),
                padding: EdgeInsets.all(
                  20,
                ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 27,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          radius: 25,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              _authService.photoURL.toString(),
                            ),
                            radius: 20,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      role == "Volunteer"
                          ? "Hi there 🖐🏼"
                          : "Post your needs 📥",
                      style: TextStyle(
                        color: Theme.of(context).selectedRowColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).selectedRowColor,
                        borderRadius: BorderRadius.circular(
                          25,
                        ),
                      ),
                      child: role == "Volunteer"
                          ? IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VolunteerPosts(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.view_carousel_outlined,
                                color: Colors.white,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatePost(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.post_add_rounded,
                                color: Colors.white,
                              ),
                            ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 40,
                ),
                width: MediaQuery.of(context).size.width * 0.80,
                child: Divider(
                  thickness: 2.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: posts,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                          ),
                                        ),
                                      );
                                    },
                                    child: Hero(
                                      tag: doc.id,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
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
                                                    backgroundImage:
                                                        NetworkImage(
                                                      doc['photo'],
                                                    ),
                                                    radius: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        doc['userName'],
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .selectedRowColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                        timeago.format(
                                                          doc['createdAt']
                                                              .toDate(),
                                                        ),
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .selectedRowColor,
                                                          fontWeight:
                                                              FontWeight.w400,
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
                                                    child:
                                                        CarouselSlider.builder(
                                                      itemCount:
                                                          doc['url'].length,
                                                      itemBuilder: (context,
                                                              index,
                                                              realIndex) =>
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
                                              height: 25,
                                            ),
                                            Container(
                                              child: Text(
                                                doc['comments']
                                                    .length
                                                    .toString() + "Comment(s)",
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .selectedRowColor,
                                                  fontWeight: FontWeight.bold,
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
                                              height: 40,
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
