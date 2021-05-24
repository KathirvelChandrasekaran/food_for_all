import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostNotifier extends ChangeNotifier {
  double _foodQuantity, _expiry;
  String _postHeading, _postContent;
  int _nosPersons, _vesselCount;
  bool _needVessel, _tiffin, _mainCourse;

  double get foodQuantity => _foodQuantity;

  double get expiry => _expiry;

  get mainCourse => _mainCourse;

  get tiffin => _tiffin;

  bool get needVessel => _needVessel;

  get vesselCount => _vesselCount;

  int get nosPersons => _nosPersons;

  get postContent => _postContent;

  String get postHeading => _postHeading;

  void notifyToCreatePostListener(
    double foodQuantity,
    expiry,
    String postHeading,
    postContent,
    int nosPersons,
    vesselCount,
    bool needVessel,
    tiffin,
    mainCourse,
  ) {
    _foodQuantity = foodQuantity;
    _expiry = expiry;
    _postHeading = postHeading;
    _postContent = postContent;
    _nosPersons = nosPersons;
    _vesselCount = vesselCount;
    _needVessel = needVessel;
    _tiffin = tiffin;
    _mainCourse = mainCourse;
    notifyListeners();
  }
}

final createPostProvider = ChangeNotifierProvider(
  (_) => CreatePostNotifier(),
);
