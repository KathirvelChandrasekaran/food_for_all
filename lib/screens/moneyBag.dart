import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/screens/moneyBagDetails.dart';
import 'package:food_for_all/utils/theming.dart';

class MoneyBag extends StatefulWidget {
  @override
  _MoneyBagState createState() => _MoneyBagState();
}

class _MoneyBagState extends State<MoneyBag>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          // Creates border
                          color: Theme.of(context).accentColor,
                        ),
                        controller: _controller,
                        unselectedLabelColor: Colors.black,
                        labelColor: Colors.white,
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.pending_actions_rounded,
                              color: Colors.black,
                            ),
                            text: 'Pending requests',
                          ),
                          Tab(
                            icon: Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.black,
                            ),
                            text: 'Completed requests',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80.0,
                      child: TabBarView(
                        controller: _controller,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.location_on),
                            title:
                                Text('Latitude: 48.09342\nLongitude: 11.23403'),
                            trailing: IconButton(
                                icon: const Icon(Icons.my_location),
                                onPressed: () {}),
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on),
                            title:
                                Text('Latitude: 48.09342\nLongitude: 11.23403'),
                            trailing: IconButton(
                                icon: const Icon(Icons.my_location),
                                onPressed: () {}),
                          ),
                        ],
                      ),
                    ),
                  ],
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
            "Request money",
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
