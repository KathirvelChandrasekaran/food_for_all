import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[_selectedIndex],
      bottomNavigationBar: FloatingNavbar(
        onTap: (int val) {
          setState(() {
            _selectedIndex = val;
          });
        },
        backgroundColor: Theme.of(context).selectedRowColor,
        borderRadius: 20,
        padding: EdgeInsets.all(
          17,
        ),
        currentIndex: _selectedIndex,
        itemBorderRadius: 15,
        selectedItemColor: Theme.of(context).selectedRowColor,
        elevation: 10,
        iconSize: 20,
        items: [
          FloatingNavbarItem(
            icon: Icons.explore,
            title: 'News Feed',
          ),
          FloatingNavbarItem(
            icon: Icons.search,
            title: 'Search',
          ),
          FloatingNavbarItem(
            icon: Icons.person,
            title: 'Profile',
          ),
        ],
      ),
    );
  }
}
