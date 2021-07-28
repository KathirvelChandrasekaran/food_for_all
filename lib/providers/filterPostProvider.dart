import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterPostProvider extends ChangeNotifier {
  bool _filterFlag = false;
  List<bool> _isFoodSelected = [false, false];
  int _startTime = 0;
  Stream<QuerySnapshot> _fetchedPost;


  Stream<QuerySnapshot> get fetchedPost => _fetchedPost;

  set startTime(int value) {
    _startTime = value;
  }

  bool get filterFlag => _filterFlag;

  List<bool> get isFoodSelected => _isFoodSelected;

  int get startTime => _startTime;


  void listenToFilters(
      List<bool> foodType, bool filterFlag, int startTime) {
    _isFoodSelected[0] = foodType[0];
    _isFoodSelected[1] = foodType[1];
    _filterFlag = filterFlag;
    _startTime = startTime;

    notifyListeners();
  }
}

final filterProvider = ChangeNotifierProvider(
  (_) => FilterPostProvider(),
);

