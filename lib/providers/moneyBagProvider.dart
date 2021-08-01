import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_for_all/services/moneyBagService.dart';

class MoneyBagNotifier extends ChangeNotifier {
  String _title = "";
  String _description = "";
  String _upiID = "";
  int _amount = 0;

  String get upiID => _upiID;

  set upiID(String value) {
    _upiID = value;
  }

  set title(String value) {
    _title = value;
  }

  String get title => _title;

  String get description => _description;

  int get amount => _amount;

  void listenToMoneyBagDetails(
    String title,
    description,
    upiID,
    int amount,
  ) {
    _title = title;
    _description = _description;
    _amount = amount;
    _upiID = upiID;

    notifyListeners();
  }

  set description(String value) {
    _description = value;
  }

  set amount(int value) {
    _amount = value;
  }
}

final moneyBagProvider = ChangeNotifierProvider(
  (_) => MoneyBagNotifier(),
);

final moneyBagDetailsProvider = Provider<MoneyBagFirebase>(
  (_) => MoneyBagFirebase(),
);

final getPendingMoneyBagProvider = StreamProvider.autoDispose<QuerySnapshot>(
  (_) => MoneyBagFirebase().getPendingMoneyBag(),
);
