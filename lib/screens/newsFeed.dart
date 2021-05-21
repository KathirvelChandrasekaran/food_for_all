import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/authServiceProvider.dart';
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
                        backgroundColor: Theme.of(context).selectedRowColor,
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
            body: Container());
      },
    );
  }
}
