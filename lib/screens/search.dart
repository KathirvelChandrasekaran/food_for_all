import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/filterPostProvider.dart';
import 'package:food_for_all/providers/newsFeedProvider.dart';
import 'package:food_for_all/screens/filters.dart';
import 'package:food_for_all/screens/viewPost.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String query;

  Widget buildFloatingSearchBar(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
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
        20,
      ),
      onQueryChanged: (query) {
        setState(() {
          query = query;
        });
        print(query);
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
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Center(
                  child: Text(
                    "Start searching",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              )),
        );
      },
      body: SingleChildScrollView(
        child: Consumer(
          builder: (context, watch, child) {
            final theme = watch(themingNotifer);
            final filters = watch(filterProvider);
            final filteredPosts =
                watch(getFilteredPost(filters.isFoodSelected).stream);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 75.0, left: 0),
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 40,
                    ),
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: Divider(
                      thickness: 2.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: Filters(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.filter_list_rounded,
                          color: Theme.of(context).accentColor,
                        ),
                        label: Text(
                          "Filter content",
                          style: TextStyle(
                            color:
                                !theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_alt_outlined,
                          color: Theme.of(context).accentColor,
                        ),
                        label: Text(
                          "Sort by Time",
                          style: TextStyle(
                            color:
                                !theme.darkTheme ? Colors.black : Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: filters.filterFlag
                              ? StreamBuilder(
                                  stream: filteredPosts,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData)
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      );
                                    if (snapshot.data.size < 1)
                                      return Center(
                                        child: Text(
                                          "Apply filter to view result️",
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 25,
                                          ),
                                        ),
                                      );
                                    return ListView(
                                      shrinkWrap: true,
                                      primary: true,
                                      scrollDirection: Axis.vertical,
                                      children: snapshot.data.docs.map(
                                        (doc) {
                                          return Column(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Center(
                                                child: BouncingWidget(
                                                  scaleFactor: 0.5,
                                                  onPressed: () {
                                                    watch(getSinglePost(doc.id));
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewPost(
                                                          snapshot: doc,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Hero(
                                                    tag: doc.id,
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
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
                                                            margin:
                                                                EdgeInsets.only(
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
                                                                    doc['photo'],
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
                                                                      doc['userName'],
                                                                      style:
                                                                          TextStyle(
                                                                        color: Theme.of(
                                                                                context)
                                                                            .selectedRowColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      timeago
                                                                          .format(
                                                                        doc['createdAt']
                                                                            .toDate(),
                                                                      ),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Theme.of(
                                                                                context)
                                                                            .selectedRowColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          doc['images']
                                                              ? Container(
                                                                  child:
                                                                      CarouselSlider
                                                                          .builder(
                                                                    itemCount: doc[
                                                                            'url']
                                                                        .length,
                                                                    itemBuilder: (context,
                                                                            index,
                                                                            realIndex) =>
                                                                        Container(
                                                                      child: Image
                                                                          .network(
                                                                        doc['url']
                                                                            [
                                                                            index],
                                                                        fit: BoxFit
                                                                            .contain,
                                                                      ),
                                                                    ),
                                                                    options:
                                                                        CarouselOptions(
                                                                      aspectRatio:
                                                                          1.0,
                                                                      enlargeCenterPage:
                                                                          true,
                                                                      autoPlay:
                                                                          true,
                                                                      viewportFraction:
                                                                          0.7,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Text(""),
                                                          Container(
                                                            child: Text(
                                                              doc['postContent'],
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .selectedRowColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 20,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 25,
                                                              right: 25,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              doc['postHeading'],
                                                              style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .selectedRowColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 20,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: 25,
                                                              right: 25,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 25,
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              doc['comments']
                                                                      .length
                                                                      .toString() +
                                                                  " Comment(s)",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            margin:
                                                                EdgeInsets.only(
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
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                            ],
                                          );
                                        },
                                      ).toList(),
                                    );
                                  },
                                )
                              : Text(
                                  "Result not found ☹️",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                  ),
                                ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search 🔍",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: buildFloatingSearchBar(context),
    );
  }
}
