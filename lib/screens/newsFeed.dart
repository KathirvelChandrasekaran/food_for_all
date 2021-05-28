import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/authServiceProvider.dart';
import 'package:food_for_all/providers/newsFeedProvider.dart';
import 'package:food_for_all/screens/createPost.dart';
import 'package:food_for_all/screens/profile.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
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
                      "Post your needs !!!",
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
                      child: IconButton(
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
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
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
                                        doc['images']
                                            ? Container(
                                                child: CarouselSlider.builder(
                                                  itemCount: doc['url'].length,
                                                  itemBuilder: (context, index,
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
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          doc['postHeading'],
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .selectedRowColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          doc['postContent'],
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .selectedRowColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          timeago.format(
                                            doc['createdAt'].toDate(),
                                          ),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .selectedRowColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                      ],
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
