import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/authServiceProvider.dart';
import 'package:food_for_all/screens/createPost.dart';
import 'package:food_for_all/screens/profile.dart';

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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
