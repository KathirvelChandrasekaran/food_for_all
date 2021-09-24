import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/providers/createPostProvider.dart';
import 'package:food_for_all/utils/theming.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key key}) : super(key: key);

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  bool _uploading = false, _visible = false;
  double _val = 0;
  CollectionReference _imageRef;
  firebase_storage.Reference ref;
  List<File> _image = [];
  final picker = ImagePicker();
  List<String> _uploadedFiles = [];
  User _auth = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _imageRef = FirebaseFirestore.instance.collection('Posts');
  }

  chooseImage() async {
    var pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    var croppedImage = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [CropAspectRatioPreset.square],
      compressQuality: 70,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: androidUiSettingsLocked(),
      iosUiSettings: iosUiSettingsLocked(),
    );

    setState(() {
      _image.add(File(croppedImage.path));
      _visible = true;
    });
    if (croppedImage.path == null) retrieveLostData();
  }

  IOSUiSettings iosUiSettingsLocked() => IOSUiSettings(
        rotateClockwiseButtonHidden: false,
        rotateButtonsHidden: false,
      );

  AndroidUiSettings androidUiSettingsLocked() => AndroidUiSettings(
        toolbarTitle: 'Crop your image Image',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        hideBottomControls: true,
      );

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) return;
    if (response.file != null)
      setState(() {
        _image.add(File(response.file.path));
      });
    else
      print(response.file);
  }

  Future uploadFile(
    double foodQuantity,
    expiry,
    String postHeading,
    postContent,
    int nosPersons,
    vesselCount,
    bool needVessel,
    tiffin,
    mainCourse,
  ) async {
    int i = 1;
    String token;
    FirebaseMessaging.instance.getToken().then((value) => token = value);

    for (var img in _image) {
      setState(
        () {
          _val = i / _image.length;
        },
      );
      print(_image);
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Posts Images/${_auth.email}/Post/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(
        () async {
          await ref.getDownloadURL().then(
            (value) {
              setState(() {
                _uploadedFiles.add(value);
              });
              i++;
            },
          );
        },
      );
    }
    _imageRef.add(
      {
        'foodQuantity': foodQuantity,
        'expiry': expiry,
        'postHeading': postHeading,
        'postContent': postContent,
        'nosPersons': nosPersons,
        'vesselCount': vesselCount,
        'needVessel': needVessel,
        'tiffin': tiffin,
        'mainCourse': mainCourse,
        'email': FirebaseAuth.instance.currentUser.email,
        'createdAt': DateTime.now(),
        // ignore: equal_keys_in_map
        'email': _auth.email,
        'userName': _auth.displayName,
        'photo': _auth.photoURL,
        'images': true,
        'url': _uploadedFiles,
        "comments": {},
        "deviceToken": token,
      },
    );
    FirebaseFirestore.instance
        .collection('PostQuantity')
        .doc(_auth.email)
        .get()
        .then(
          (value) => {
            FirebaseFirestore.instance
                .collection("PostQuantity")
                .doc(_auth.email)
                .update(
              {
                'foodQuantity':
                    value.data()["foodQuantity"] + foodQuantity.toInt(),
                'nosPersons': value.data()["nosPersons"] + nosPersons.toInt(),
              },
            )
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final theme = watch(themingNotifer);
        final postDetails = watch(createPostProvider);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Upload image",
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          body: Stack(
            children: [
              GridView.builder(
                itemCount: _image.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return index == 0
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Pick image to upload",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.darkTheme
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(
                                    _image[index - 1],
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        );
                },
              ),
              _uploading
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Text(
                              'Uploading...',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            value: _val,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.yellowAccent,
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: _visible,
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      _uploading = true;
                    });
                    uploadFile(
                            postDetails.foodQuantity,
                            postDetails.expiry,
                            postDetails.postHeading,
                            postDetails.postContent,
                            postDetails.nosPersons,
                            postDetails.vesselCount,
                            postDetails.needVessel,
                            postDetails.tiffin,
                            postDetails.mainCourse)
                        .whenComplete(
                      () => Navigator.popAndPushNamed(context, '/postSuccess'),
                    );
                  },
                  child: Icon(
                    Icons.cloud_upload,
                    color: !theme.darkTheme
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                heroTag: null,
                backgroundColor: Colors.white,
                onPressed: () => !_uploading ? chooseImage() : null,
                child: Icon(
                  Icons.upload_file,
                  color: !theme.darkTheme
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
