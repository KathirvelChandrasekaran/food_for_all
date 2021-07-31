import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/screens/moneyBagDetails.dart';
import 'package:food_for_all/utils/theming.dart';

class MoneyBag extends StatefulWidget {
  @override
  _MoneyBagState createState() => _MoneyBagState();
}

class _MoneyBagState extends State<MoneyBag> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final theme = watch(themingNotifer);
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: Text(
                        ' "Giving is not just about making a donation, '
                        'it is about making a difference"',
                        style: TextStyle(
                          color: !theme.darkTheme ? Colors.white : Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: Text(
                        '  - Kathy Calvin ',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: Text(
                        'Lets show our little help 🤝🏼'.toUpperCase(),
                        style: TextStyle(
                          color: !theme.darkTheme ? Colors.white : Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: "donate",
          icon: Icon(
            Icons.volunteer_activism_rounded,
            color: Colors.white,
          ),
          label: Text(
            "Donate Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoneyBagDetails(),
              ),
            );
          },
        ),
      );
    });
  }
}
