import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/screens/acceptRequest.dart';
import 'package:food_for_all/screens/comments.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// ignore: must_be_immutable
class ViewPost extends StatefulWidget {
  QueryDocumentSnapshot snapshot;
  bool acceptRequest;
  ViewPost({this.snapshot, this.acceptRequest});

  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost> {
  TextEditingController commentController = TextEditingController();
  DocumentSnapshot doc;
  List<dynamic> comments;
  DateTime postedAt;
  var logger = Logger();

  final _languageModelManager = GoogleMlKit.nlp.translateLanguageModelManager();
  bool _translate = false;
  var _translatedContent = '',
      _translatedHeading = '',
      _nos = "",
      _quantity = "",
      _expiry = "",
      _count = "",
      _food = "",
      _type = "";
  final _onDeviceTranslator = GoogleMlKit.nlp.onDeviceTranslator(
      sourceLanguage: TranslateLanguage.ENGLISH,
      targetLanguage: TranslateLanguage.TAMIL);

  @override
  void dispose() {
    _onDeviceTranslator.close();
    super.dispose();
  }

  Future<void> downloadModel() async {
    var result = await _languageModelManager.downloadModel('en');
    print('Model downloaded: $result');
    result = await _languageModelManager.downloadModel('ta');
    print('Model downloaded: $result');
  }

  Future<void> deleteModel() async {
    var result = await _languageModelManager.deleteModel('en');
    print('Model deleted: $result');
    result = await _languageModelManager.deleteModel('ta');
    print('Model deleted: $result');
  }

  Future<void> getAvailableModels() async {
    var result = await _languageModelManager.getAvailableModels();
    print('Available models: $result');
  }

  Future<void> translate() async {
    var content =
        await _onDeviceTranslator.translateText(widget.snapshot['postContent']);
    var heading =
        await _onDeviceTranslator.translateText(widget.snapshot['postHeading']);
    var nos =
        await _onDeviceTranslator.translateText("Number of persons can eat");
    var expiry = await _onDeviceTranslator.translateText("Expiry");
    var quantity = await _onDeviceTranslator.translateText("Quantity");
    var count =
        await _onDeviceTranslator.translateText("Utensils count needed");
    var food = await _onDeviceTranslator.translateText("Food type");
    var type = await _onDeviceTranslator.translateText("Main Course dishes");
    setState(() {
      _translate = true;
      _translatedContent = content;
      _translatedHeading = heading;
      _quantity = quantity;
      _nos = nos;
      _expiry = expiry;
      _count = count;
      _food = food;
      _type = type;
    });
  }

  @override
  void initState() {
    super.initState();
    doc = widget.snapshot;
    Timestamp t = doc['createdAt'];
    setState(() {
      postedAt = t.toDate();
      _translate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.translate_rounded),
                onPressed: () {
                  getAvailableModels();
                  downloadModel();
                  translate();
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Container(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    widget.snapshot['photo'],
                                  ),
                                  radius: 30,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.snapshot['userName'],
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).selectedRowColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMMMd()
                                          .add_jm()
                                          .format(postedAt),
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  child: widget.snapshot['foodQuantity'] > 20
                                      ? IconButton(
                                          onPressed: () {
                                            print("share");
                                            Share.share(
                                                "Hey! Will you help this 😄",
                                                subject:
                                                    "There is availability of ${widget.snapshot['foodQuantity']}Kg food from ${widget.snapshot['userName']}");
                                          },
                                          icon: Icon(
                                            Icons.share_rounded,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          tooltip: "Share this content",
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          widget.snapshot['images']
                              ? Container(
                                  child: CarouselSlider.builder(
                                    itemCount: widget.snapshot['url'].length,
                                    itemBuilder: (context, index, realIndex) =>
                                        Container(
                                      child: Image.network(
                                        widget.snapshot['url'][index],
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
                              !_translate
                                  ? widget.snapshot['postContent']
                                  : _translatedContent,
                              style: TextStyle(
                                color: Theme.of(context).selectedRowColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 25,
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
                          Expanded(
                            child: Container(
                              child: Text(
                                !_translate
                                    ? widget.snapshot['postHeading']
                                    : _translatedHeading,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              margin: EdgeInsets.only(
                                left: 25,
                                right: 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  !_translate ? "Quantity" : _quantity,
                                  style: TextStyle(
                                    color: Theme.of(context).selectedRowColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
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
                              Container(
                                child: Text(
                                  widget.snapshot['foodQuantity'].toString() +
                                      " Kg",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  !_translate
                                      ? "Number of persons can eat"
                                      : _nos,
                                  style: TextStyle(
                                    color: Theme.of(context).selectedRowColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
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
                              Container(
                                child: Text(
                                  widget.snapshot['nosPersons'].toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  !_translate ? "Expiry" : _expiry,
                                  style: TextStyle(
                                    color: Theme.of(context).selectedRowColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
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
                              Container(
                                child: Text(
                                  widget.snapshot['expiry'].toString() + " Hrs",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  !_translate ? "Vessel count needed" : _count,
                                  style: TextStyle(
                                    color: Theme.of(context).selectedRowColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
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
                              Container(
                                child: Text(
                                  widget.snapshot['vesselCount'].toString(),
                                  style: TextStyle(
                                    color: Theme.of(context).selectedRowColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  !_translate ? "Food type" : _food,
                                  style: TextStyle(
                                    color: Theme.of(context).selectedRowColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
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
                              (widget.snapshot['mainCourse'] &&
                                      widget.snapshot['tiffin'])
                                  ? Container(
                                      child: Text(
                                        "Main Course and Tiffin",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .selectedRowColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      margin: EdgeInsets.only(
                                        left: 25,
                                        right: 25,
                                      ),
                                    )
                                  : widget.snapshot['mainCourse']
                                      ? Container(
                                          child: Text(
                                            !_translate ? "Main Course" : _type,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .selectedRowColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                            ),
                                          ),
                                          margin: EdgeInsets.only(
                                            left: 25,
                                            right: 25,
                                          ),
                                        )
                                      : widget.snapshot['tiffin']
                                          ? Container(
                                              child: Text(
                                                !_translate ? "Tiffin" : _type,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .selectedRowColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              margin: EdgeInsets.only(
                                                left: 25,
                                                right: 25,
                                              ),
                                            )
                                          : Text("")
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: !widget.acceptRequest
                    ? FloatingActionButton.extended(
                        heroTag: "delivered",
                        icon: Icon(
                          Icons.local_shipping_rounded,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Delivered",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          showModalBottomSheet(
                            context: context,
                            builder: (builder) {
                              return Container(
                                height: 250.0,
                                color: Colors.transparent,
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      topRight: const Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Consumer(
                                    builder: (context, watch, child) {
                                      final theme = watch(themingNotifer);
                                      return Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Are you sure you delivered this post?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: theme.darkTheme
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.cancel_rounded,
                                                    size: 35,
                                                    color: Theme.of(context)
                                                        .errorColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection("Posts")
                                                        .doc(doc.id)
                                                        .update({
                                                      'delivered': true,
                                                      'deliveredBy':
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              .displayName,
                                                      'deliveredAt':
                                                          DateTime.now(),
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "Notifications")
                                                        .doc(doc['email'])
                                                        .update({
                                                      'notifications':
                                                          FieldValue
                                                              .arrayUnion([
                                                        {
                                                          "title":
                                                              "Your request has been delivered 🤩",
                                                          "body":
                                                              "${FirebaseAuth.instance.currentUser.displayName} has delivered your request!",
                                                          "createdAt":
                                                              DateTime.now(),
                                                        }
                                                      ])
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection("Posts")
                                                        .doc(doc.id)
                                                        .delete();
                                                    Navigator.popUntil(
                                                      context,
                                                      (route) => route.isFirst,
                                                    );
                                                  },
                                                  icon: Icon(
                                                    Icons.done_all_rounded,
                                                    size: 35,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : null,
              ),
              SizedBox(height: 15),
              FloatingActionButton.extended(
                heroTag: "comment",
                icon: Icon(
                  Icons.comment,
                  color: Colors.white,
                ),
                label: Text(
                  "Comments",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Comments(
                        snapshot: widget.snapshot,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              FloatingActionButton.extended(
                heroTag: "accept",
                icon: Icon(
                  Icons.task_alt_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  "Accept",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onPressed: widget.snapshot['email'] ==
                            FirebaseAuth.instance.currentUser.email ||
                        !widget.acceptRequest
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AcceptRequest(
                              snapshot: widget.snapshot,
                            ),
                          ),
                        );
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}
