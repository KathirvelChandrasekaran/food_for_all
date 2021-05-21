import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:food_for_all/providers/registerDetailsProvider.dart';
import 'package:food_for_all/screens/registerDetails.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  User userCredential;

  Profile({this.userCredential});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String photoUrl, newPhotoUrl;
  bool status = false;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    setState(() {
      this.photoUrl = widget.userCredential.photoURL;
      this.newPhotoUrl =
          photoUrl.substring(0, this.photoUrl.length - 5) + "s500-c";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (index) {
              if (index == 1) logout();
              if (index == 2)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterDetails(
                      title: "Edit details",
                      edit: true,
                    ),
                  ),
                );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15.0),
              ),
            ),
            itemBuilder: (BuildContext bc) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    color: Theme.of(context).accentColor,
                    size: 25,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Theme.of(context).accentColor,
                    size: 25,
                  ),
                  title: Text(
                    "Edit details",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                  value: 3,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          20.0,
                        ),
                        child: Consumer(
                          builder: (context, watch, child) {
                            final themingListener = watch(themingNotifer);
                            return FlutterSwitch(
                              width: 100.0,
                              height: 50.0,
                              toggleSize: 50.0,
                              value: themingListener.darkTheme,
                              borderRadius: 50.0,
                              activeToggleColor: Colors.black,
                              inactiveToggleColor: Colors.white,
                              activeSwitchBorder: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                              inactiveSwitchBorder: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                              activeColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              inactiveColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              activeIcon: Image.asset(
                                "images/moon.png",
                                height: 500,
                              ),
                              inactiveIcon: Image.asset(
                                "images/sun.png",
                              ),
                              onToggle: (val) {
                                setState(() {
                                  themingListener.toggleTheme();
                                  status = themingListener.darkTheme;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).selectedRowColor,
                  radius: 137,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    radius: 132,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        this.newPhotoUrl,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text(
                    widget.userCredential.displayName,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alternate_email_rounded,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text(
                    widget.userCredential.email,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Consumer(
                builder: (context, watch, child) {
                  final userDetails = watch(getRegisterDetailsProvider.stream);
                  return StreamBuilder(
                    stream: userDetails,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return CircularProgressIndicator();
                      else {
                        Map<dynamic, dynamic> data =
                            new Map<String, dynamic>.from(snapshot.data.data());
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_city_rounded,
                                  color: Theme.of(context).accentColor,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Container(
                                  height: 100,
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Text(
                                    data['address'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone_android_rounded,
                                  color: Theme.of(context).accentColor,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Text(
                                  data['mobile'].toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.popAndPushNamed(
      context,
      '/wrapper',
    );
  }
}
