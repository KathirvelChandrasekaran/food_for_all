import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/screens/imageUpload.dart';
import 'package:food_for_all/screens/postSuccess.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:food_for_all/widgets/inputs.dart';
import 'package:numberpicker/numberpicker.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _formKey = GlobalKey<FormState>();
  final _postHeadingController = TextEditingController();
  final _postContentController = TextEditingController();

  double _foodQuantity = 0.0, _expiry = 0.0;
  int _nosPersons = 0, _vesselCount = 0;
  bool _needVessel = false,
      _tiffin = false,
      _mainCourse = false,
      _imageUpload = false;

  void toggleVessel(bool val) {
    _needVessel
        ? setState(() {
            _needVessel = false;
            _vesselCount = 1;
          })
        : setState(() {
            _needVessel = true;
            _vesselCount = 0;
          });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Post",
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
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InputTextMethod(
                      context,
                      theme,
                      TextInputType.text,
                      _postHeadingController,
                      100,
                      "Post Heading",
                      Icon(
                        Icons.title_rounded,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        controller: _postContentController,
                        decoration: InputDecoration(
                          labelText: "Post Content",
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                          prefixIcon: Icon(
                            Icons.description_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  theme.darkTheme ? Colors.black : Colors.white,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  theme.darkTheme ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.35,
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
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Food quantity",
                              style: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Kilos",
                                  style: TextStyle(
                                    color: theme.darkTheme
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "Grams",
                                  style: TextStyle(
                                    color: theme.darkTheme
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            DecimalNumberPicker(
                              value: _foodQuantity,
                              minValue: 0,
                              maxValue: 100,
                              decimalPlaces: 2,
                              haptics: true,
                              textStyle: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                              onChanged: (value) => setState(
                                () => _foodQuantity = value,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '$_foodQuantity Kg',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.35,
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
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "No. of Persons",
                              style: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Text(
                              "Head Count",
                              style: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            NumberPicker(
                              value: _nosPersons,
                              minValue: 0,
                              maxValue: 1000,
                              step: 1,
                              haptics: true,
                              textStyle: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                              onChanged: (value) => setState(
                                () => _nosPersons = value,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '$_nosPersons Person(s)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.35,
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
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Expiry duration",
                              style: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Hours",
                                  style: TextStyle(
                                    color: theme.darkTheme
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "Minutes",
                                  style: TextStyle(
                                    color: theme.darkTheme
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            DecimalNumberPicker(
                              value: _expiry,
                              minValue: 0,
                              maxValue: 100,
                              decimalPlaces: 2,
                              haptics: true,
                              textStyle: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                              onChanged: (value) => setState(
                                () => _expiry = value,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '$_expiry',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.40,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "No. of Vessels",
                              style: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 25,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Switch(
                                  value: _needVessel,
                                  onChanged: toggleVessel,
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                                Container(
                                  child: _needVessel
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: 25,
                                            ),
                                            SizedBox(
                                              height: 13,
                                            ),
                                            Text(
                                              "Vessel Count",
                                              style: TextStyle(
                                                color: theme.darkTheme
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            NumberPicker(
                                              value: _vesselCount,
                                              minValue: 0,
                                              maxValue: 1000,
                                              step: 1,
                                              haptics: true,
                                              textStyle: TextStyle(
                                                color: theme.darkTheme
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.black,
                                              ),
                                              onChanged: (value) => setState(
                                                () => _vesselCount = value,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              '$_vesselCount vessels',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: theme.darkTheme
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Colors.black,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "Toggle the switch!",
                                          style: TextStyle(
                                            color: theme.darkTheme
                                                ? Theme.of(context).primaryColor
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: new EdgeInsets.all(22.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Choose the food type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.darkTheme
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CheckboxListTile(
                            secondary: Icon(
                              Icons.dinner_dining_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              'Tiffin',
                              style: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                fontSize: 25,
                              ),
                            ),
                            value: _tiffin,
                            onChanged: (bool value) {
                              setState(
                                () {
                                  _tiffin = value;
                                },
                              );
                            },
                          ),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.trailing,
                            secondary: Icon(
                              Icons.rice_bowl_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              'Main course',
                              style: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                fontSize: 25,
                              ),
                            ),
                            value: _mainCourse,
                            onChanged: (bool value) {
                              setState(
                                () {
                                  _mainCourse = value;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: new EdgeInsets.all(22.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Choose the image upload status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.darkTheme
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CheckboxListTile(
                            secondary: Icon(
                              Icons.upload_file_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              'Upload image',
                              style: TextStyle(
                                color: theme.darkTheme
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                fontSize: 25,
                              ),
                            ),
                            value: _imageUpload,
                            onChanged: (bool value) {
                              setState(
                                () {
                                  _imageUpload = value;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _imageUpload
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageUpload(),
                                ),
                              )
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PostSuccess(),
                                ),
                              );
                        ;
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 125),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 20,
                          color: theme.darkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
