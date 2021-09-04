import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterPostProvider extends ChangeNotifier {
  bool _filterFlag = false;
  bool _optionFlag = false;
  List<bool> _isFoodSelected = [false, false];
  int _startTime = 0, _foodQuantity = 0, _personCount = 0, _vesselCount = 0;
  bool _oldPost = false;
  bool _newPost = false;
  bool _timeFlag = false;
  bool _searchPost = false;

  get foodQuantity => _foodQuantity;

  set foodQuantity(value) {
    _foodQuantity = value;
  }

  set personCount(value) {
    _personCount = value;
  }

  get vesselCount => _vesselCount;

  set vesselCount(value) {
    _vesselCount = value;
  }

  set startTime(int value) {
    _startTime = value;
  }

  bool get filterFlag => _filterFlag;
  bool get searchPost => _searchPost;

  bool get timeFlag => _timeFlag;

  bool get optionFlag => _optionFlag;

  List<bool> get isFoodSelected => _isFoodSelected;

  int get startTime => _startTime;

  int get personCount => _personCount;

  bool get newPost => _newPost;

  bool get oldPost => _oldPost;

  void listenToFilters(List<bool> foodType, int startTime, foodQuantity,
      personCount, vesselCount) {
    _isFoodSelected[0] = foodType[0];
    _isFoodSelected[1] = foodType[1];
    _startTime = startTime;
    _foodQuantity = foodQuantity;
    _personCount = personCount;
    _vesselCount = _vesselCount;

    notifyListeners();
  }

  set optionFlag(bool value) {
    _optionFlag = value;
  }

  void listenToFilterFlag(bool filterFlag) {
    _filterFlag = filterFlag;

    notifyListeners();
  }

  void listenToTimeFlag(bool timeFlag) {
    _timeFlag = timeFlag;

    notifyListeners();
  }

  void listenToOptionFlag(bool optionFlag) {
    _optionFlag = optionFlag;

    notifyListeners();
  }

  void listenToSearchFlag(bool searchFlag) {
    _searchPost = searchFlag;

    notifyListeners();
  }

  void listenToTimeFilter(bool oldPost, newPost) {
    _oldPost = oldPost;
    _newPost = newPost;

    notifyListeners();
  }
}

final filterProvider = ChangeNotifierProvider(
  (_) => FilterPostProvider(),
);
