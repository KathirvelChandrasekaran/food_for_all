import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/screens/registerDetails.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:food_for_all/widgets/buttons.dart';

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
                RoundedButton(
                    context,
                    'School / College',
                    15,
                    100,
                    RegisterDetails(
                      title: "More about you",
                      edit: false,
                    ),
                    theme.darkTheme ? Colors.white : Colors.black),
                SizedBox(
                  height: 15,
                ),
                RoundedButton(
                    context,
                    'NGO',
                    15,
                    155,
                    RegisterDetails(
                      title: "More about you",
                      edit: false,
                    ),
                    theme.darkTheme ? Colors.white : Colors.black),
                SizedBox(
                  height: 15,
                ),
                RoundedButton(
                    context,
                    'Volunteer',
                    15,
                    130,
                    RegisterDetails(
                      title: "More about you",
                      edit: false,
                    ),
                    theme.darkTheme ? Colors.white : Colors.black),
                SizedBox(
                  height: 15,
                ),
                RoundedButton(
                    context,
                    'General User',
                    15,
                    115,
                    RegisterDetails(
                      title: "More about you",
                      edit: false,
                    ),
                    theme.darkTheme ? Colors.white : Colors.black),
              ],
            ),
          );
        },
      )
    );
  }
}
