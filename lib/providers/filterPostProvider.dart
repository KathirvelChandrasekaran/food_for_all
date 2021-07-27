import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_for_all/services/filterPostService.dart';

class FilterPostProvider extends ChangeNotifier {
  bool _filterFlag = false;

  bool get filterFlag => _filterFlag;
  List<bool> _isFoodSelected = [false, false];

  List<bool> get isFoodSelected => _isFoodSelected;

  void listenToFilters(List<bool> foodType, bool filterFlag) {
    _isFoodSelected[0] = foodType[0];
    _isFoodSelected[1] = foodType[1];
    _filterFlag = filterFlag;

    notifyListeners();
  }
}

final filterProvider = ChangeNotifierProvider(
  (_) => FilterPostProvider(),
);

final filterPostProvider = Provider(
  (ref) => FilterPostService(),
);

final getFilteredPost =
    StreamProvider.autoDispose.family<QuerySnapshot, List<bool>>(
  (ref, filters) {
    final posts = ref.read(filterPostProvider);
    return posts.get(filters);
  },
);
