import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/filterPostProvider.dart';
import 'package:food_for_all/providers/newsFeedProvider.dart';
import 'package:food_for_all/screens/filters.dart';
import 'package:food_for_all/screens/searchScreen.dart';
import 'package:food_for_all/screens/viewPost.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool timePost = false;

  void createSnackBar(String message) {
    final snackBar = new SnackBar(
      content: new Text(message),
      backgroundColor: Theme.of(context).accentColor,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backwardsCompatibility: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 10),
            child: Container(
              height: 75,
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                icon: Icon(
                  Icons.search_rounded,
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Consumer(
          builder: (context, watch, child) {
            final theme = watch(themingNotifer);
            final filters = watch(filterProvider);
            if (filters.newPost)
              timePost = filters.newPost;
            else
              timePost = false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            builder: (context) {
                              return Container(
                                height: 150,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.hourglass_top_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text(
                                        'Recent Post',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                      onTap: () {
                                        filters.listenToFilterFlag(false);
                                        filters.listenToTimeFlag(true);
                                        filters.listenToTimeFilter(false, true);
                                        Navigator.pop(context);
                                        createSnackBar("Showing New Post ???????");
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.hourglass_bottom_rounded,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      title: Text(
                                        'Old Post',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 20,
                                        ),
                                      ),
                                      onTap: () {
                                        filters.listenToFilterFlag(false);
                                        filters.listenToTimeFlag(true);
                                        filters.listenToTimeFilter(true, false);
                                        Navigator.pop(context);
                                        createSnackBar("Showing Old Post ???????");
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
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
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: filters.filterFlag
                              ? StreamBuilder(
                                  stream: filters.optionFlag
                                      ? FirebaseFirestore.instance
                                          .collection("Posts")
                                          .where('mainCourse',
                                              isEqualTo:
                                                  filters.isFoodSelected[0])
                                          .where('tiffin',
                                              isEqualTo:
                                                  filters.isFoodSelected[1])
                                          .where(
                                            'expiry',
                                            isLessThan: filters.startTime,
                                          )
                                          .where('nosPersons',
                                              isEqualTo: filters.personCount)
                                          .where('foodQuantity',
                                              isEqualTo: filters.foodQuantity)
                                          .where('vesselCount',
                                              isEqualTo: filters.vesselCount)
                                          .orderBy('expiry')
                                          .get()
                                          .asStream()
                                      : FirebaseFirestore.instance
                                          .collection("Posts")
                                          .where('mainCourse',
                                              isEqualTo:
                                                  filters.isFoodSelected[0])
                                          .where('tiffin',
                                              isEqualTo:
                                                  filters.isFoodSelected[1])
                                          .where(
                                            'expiry',
                                            isLessThan: filters.startTime,
                                          )
                                          .get()
                                          .asStream(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData)
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      );
                                    if (snapshot.data.size < 1) {
                                      return Text(
                                        "No results found ????",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25,
                                        ),
                                      );
                                    }
                                    return ListView(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      children: snapshot.data.docs.map((doc) {
                                        print(doc.id);
                                        return Center(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Center(
                                                child: BouncingWidget(
                                                  scaleFactor: 0.5,
                                                  onPressed: () {
                                                    watch(
                                                        getSinglePost(doc.id));
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
                                                              0.90,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
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
                                                                        color: Theme.of(context)
                                                                            .selectedRowColor,
                                                                        fontWeight:
                                                                            FontWeight.w600,
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
                                                                        color: Theme.of(context)
                                                                            .selectedRowColor,
                                                                        fontWeight:
                                                                            FontWeight.w400,
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
                                                                  child: CarouselSlider
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
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                )
                              : filters.timeFlag
                                  ? StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("Posts")
                                          .orderBy(
                                            'createdAt',
                                            descending: timePost,
                                          )
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData)
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                          );
                                        if (snapshot.data.size < 1) {
                                          return Text(
                                            "No results found ????",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 25,
                                            ),
                                          );
                                        }
                                        return ListView(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          children:
                                              snapshot.data.docs.map((doc) {
                                            // print(doc.id);
                                            return Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Center(
                                                    child: BouncingWidget(
                                                      scaleFactor: 0.5,
                                                      onPressed: () {
                                                        watch(getSinglePost(
                                                            doc.id));
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ViewPost(
                                                              snapshot: doc,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Hero(
                                                        tag: doc.id,
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.90,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              15,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    Colors.grey,
                                                                blurRadius:
                                                                    10.0,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
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
                                                                      radius:
                                                                          30,
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
                                                                            color:
                                                                                Theme.of(context).selectedRowColor,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          timeago
                                                                              .format(
                                                                            doc['createdAt'].toDate(),
                                                                          ),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Theme.of(context).selectedRowColor,
                                                                            fontWeight:
                                                                                FontWeight.w400,
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
                                                                      child: CarouselSlider
                                                                          .builder(
                                                                        itemCount:
                                                                            doc['url'].length,
                                                                        itemBuilder: (context,
                                                                                index,
                                                                                realIndex) =>
                                                                            Container(
                                                                          child:
                                                                              Image.network(
                                                                            doc['url'][index],
                                                                            fit:
                                                                                BoxFit.contain,
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
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .selectedRowColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
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
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .selectedRowColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
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
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black54,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
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
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      },
                                    )
                                  : Text(
                                      "Apply filters to see posts ????",
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
}
