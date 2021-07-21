import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/registerDetailsProvider.dart';
import 'package:food_for_all/screens/registerDetails.dart';
import 'package:food_for_all/utils/theming.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Choose your role",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final theme = watch(themingNotifer);
          return Center(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'images/Role.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read(registerProvider)
                        .listenToRegisterDetailsRoleNotifier(
                          "School / College",
                        );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterDetails(
                          title: "More about you",
                          edit: false,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "School / College",
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.darkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read(registerProvider)
                        .listenToRegisterDetailsRoleNotifier(
                          "NGO",
                        );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterDetails(
                          title: "More about you",
                          edit: false,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 155),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "NGO",
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.darkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read(registerProvider)
                        .listenToRegisterDetailsRoleNotifier(
                          "Volunteer",
                        );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterDetails(
                          title: "More about you",
                          edit: false,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 130),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Volunteer",
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.darkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read(registerProvider)
                        .listenToRegisterDetailsRoleNotifier(
                          "General User",
                        );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterDetails(
                          title: "More about you",
                          edit: false,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 115),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "General User",
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.darkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
