import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressNotifier extends ChangeNotifier {
  String _address = "";

  String get address => _address;

  void listenToAddressNotifier(String address) {
    _address = address;
    notifyListeners();
  }
}

final addressProvider = ChangeNotifierProvider(
  (_) => AddressNotifier(),
);
