import 'package:algolia/algolia.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/utils/algoliaManager.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String queryText;

  bool _searching = false;
  List<AlgoliaObjectSnapshot> _results = [];

  _search(String q) async {
    setState(() {
      _searching = true;
    });
    print(queryText);
    AlgoliaQuery query = AlgoliaManager.algolia.instance.index('posts');
    query = query.query(q);
    _results = (await query.getObjects()).hits;
    print(_results);
    setState(() {
      _searching = false;
    });
  }

  Widget buildFloatingSearchBar(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Consumer(
      builder: (context, watch, child) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: FloatingSearchBar(
            hint: 'Food quantity, No. of persons, food type...',
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 500),
            transitionCurve: Curves.easeInCubic,
            physics: const BouncingScrollPhysics(),
            axisAlignment: isPortrait ? 0.0 : -1.0,
            openAxisAlignment: 0.0,
            width: isPortrait ? 600 : 500,
            debounceDelay: const Duration(milliseconds: 50),
            borderRadius: BorderRadius.circular(
              15,
            ),
            onSubmitted: (val) {
              setState(() {
                queryText = val;
              });
              _search(queryText);
            },
            transition: CircularFloatingSearchBarTransition(),
            actions: [
              FloatingSearchBarAction(
                showIfOpened: false,
                child: CircularButton(
                  icon: Icon(
                    Icons.category_outlined,
                  ),
                  onPressed: () {},
                ),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            // automaticallyImplyBackButton: false,
            builder: (context, transition) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                    color: Colors.white, elevation: 4.0, child: Container()),
              );
            },
            body: Container(
              child: _searching == true
                  ? Center(
                      child: Container(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    )
                  : _results.length == 0
                      ? Center(
                          child: Text(
                            "No results found",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 25,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (BuildContext context, int index) {
                            AlgoliaObjectSnapshot snap = _results[index];
                            var parsedDate =
                                DateTime.parse(snap.data['createdAt']);
                            return Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.90,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
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
                                                  MainAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    snap.data['photo'],
                                                  ),
                                                  radius: 30,
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snap.data['userName'],
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .selectedRowColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      timeago
                                                          .format(parsedDate),
                                                      style: TextStyle(
                                                        color: Theme.of(context)
                                                            .selectedRowColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          snap.data['images']
                                              ? Container(
                                                  child: CarouselSlider.builder(
                                                    itemCount:
                                                        snap.data['url'].length,
                                                    itemBuilder: (context,
                                                            index, realIndex) =>
                                                        Container(
                                                      child: Image.network(
                                                        snap.data['url'][index],
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    options: CarouselOptions(
                                                      aspectRatio: 1.0,
                                                      enlargeCenterPage: true,
                                                      autoPlay: true,
                                                      viewportFraction: 0.7,
                                                    ),
                                                  ),
                                                )
                                              : Text(""),
                                          Container(
                                            child: Text(
                                              snap.data['postContent'],
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .selectedRowColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                              ),
                                              overflow: TextOverflow.ellipsis,
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
                                            child: Text(
                                              snap.data['postHeading'],
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .selectedRowColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            margin: EdgeInsets.only(
                                              left: 25,
                                              right: 25,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildFloatingSearchBar(context),
    );
  }
}
