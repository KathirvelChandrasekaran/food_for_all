import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/modals/chartModal.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:google_fonts/google_fonts.dart';

class ChartsScreen extends StatefulWidget {
  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  List<charts.Series<PostQuantity, String>> _seriesBarData = [];
  List<PostQuantity> myData;
  int _postCount = 0;

  _generateData(myData) {
    _seriesBarData.add(
      charts.Series(
        domainFn: (_, __) => "No. of Persons",
        measureFn: (PostQuantity post, _) => post.nosPersons,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
          Color(0xffafa2ff),
        ),
        id: "nosPersons",
        data: myData,
        labelAccessorFn: (PostQuantity post, _) => "${post.nosPersons}",
      ),
    );
    _seriesBarData.add(
      charts.Series(
        domainFn: (_, __) => "Food Quantity",
        measureFn: (PostQuantity post, _) => post.foodQuantity,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        id: "FoodQuantity",
        data: myData,
        labelAccessorFn: (PostQuantity post, _) => "${post.foodQuantity}",
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('Posts')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser.email)
        .get()
        .then(
          (value) => {
            setState(
              () {
                _postCount = value.size;
              },
            ),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Contribution",
          style: GoogleFonts.oswald(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('PostQuantity')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).accentColor,
            ),
          );
        else {
          List<PostQuantity> post = snapshot.data.docs
              .map((docSnap) => PostQuantity.fromMap(docSnap.data()))
              .toList();
          return _buildChart(context, post);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<PostQuantity> post) {
    myData = post;
    _generateData(myData);
    return Consumer(builder: (context, watch, child) {
      final theme = watch(themingNotifer);
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      color: Color(0xffafa2ff),
                      height: 20,
                      width: 20,
                    ),
                    Container(
                      child: Text(
                        "No. of Persons",
                        style: TextStyle(
                          color: theme.darkTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.red,
                      height: 20,
                      width: 20,
                    ),
                    Container(
                      child: Text(
                        "Food Quantity",
                        style: TextStyle(
                          color: theme.darkTheme ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: Expanded(
                    child: charts.BarChart(
                      _seriesBarData,
                      animate: true,
                      animationDuration: Duration(seconds: 1),
                      defaultRenderer: charts.BarRendererConfig(
                          cornerStrategy: const charts.ConstCornerStrategy(10)),
                      selectionModels: [
                        charts.SelectionModelConfig(
                          changedListener: (charts.SelectionModel model) {
                            print(model.selectedSeries[0]
                                .measureFn(model.selectedDatum[0].index));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: theme.darkTheme ? Colors.black : Colors.white,
                    ),
                    text: _postCount.toString(),
                    children: [
                      TextSpan(
                        text: ' Posts 🔥',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 25,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: theme.darkTheme ? Colors.black : Colors.white,
                    ),
                    text: post.first.nosPersons.toString(),
                    children: [
                      TextSpan(
                        text: ' Persons been helped by you 🤝🏼',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 25,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: theme.darkTheme ? Colors.black : Colors.white,
                    ),
                    text: post.first.foodQuantity.toString(),
                    children: [
                      TextSpan(
                        text: ' Kg of food dispensed 🍜',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 25,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
