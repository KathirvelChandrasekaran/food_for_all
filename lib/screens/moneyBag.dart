import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/moneyBagProvider.dart';
import 'package:food_for_all/screens/moneyBagDetails.dart';
import 'package:food_for_all/screens/viewMoneyBagRequest.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      final pending = watch(getPendingMoneyBagProvider.stream);
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
                      height: 500,
                      child: TabBarView(
                        controller: _controller,
                        children: [
                          StreamBuilder(
                            stream: pending,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).accentColor,
                                  ),
                                );
                              if (snapshot.data.size < 1)
                                return Center(
                                  child: Text(
                                    "No Request found ☹️",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                );
                              return Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  // scrollDirection: Axis.vertical,
                                  // primary: true,
                                  // shrinkWrap: true,
                                  children: snapshot.data.docs.map((doc) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Center(
                                          child: BouncingWidget(
                                            scaleFactor: 0.5,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewMoneyBagDetails(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.85,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      left: 20,
                                                      top: 30,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage:
                                                              NetworkImage(
                                                            doc['url'],
                                                          ),
                                                          radius: 30,
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              doc['name'],
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .selectedRowColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            Text(
                                                              timeago.format(
                                                                doc['createdAt']
                                                                    .toDate(),
                                                              ),
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .selectedRowColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      doc['title'],
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .selectedRowColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 20,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    margin: EdgeInsets.only(
                                                      left: 25,
                                                      right: 25,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    child: Expanded(
                                                      child: Text(
                                                        doc['description'],
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .selectedRowColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 20,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                      left: 25,
                                                      right: 25,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.money_rounded,
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                      ),
                                                      Text(
                                                        doc['amount']
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .selectedRowColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              );
                            },
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
