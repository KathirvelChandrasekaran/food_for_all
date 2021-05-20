import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:food_for_all/screens/newsFeed.dart';
import 'package:food_for_all/screens/profile.dart';
import 'package:food_for_all/screens/search.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  List screenList = [
    NewsFeed(),
    Search(),
    Profile(
      userCredential: FirebaseAuth.instance.currentUser,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[_selectedIndex],
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.bounceIn,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedIndex: _selectedIndex,
        showElevation: false,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        iconSize: 25,
        height: 70,
        items: [
          FlashyTabBarItem(
            icon: Icon(
              Icons.feed_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'News Feed',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Search',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
