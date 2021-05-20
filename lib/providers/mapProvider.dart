import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressNotifier extends ChangeNotifier {
  String _address = "";
  LatLng _latLng;
  String get address => _address;

  LatLng get latLng => _latLng;

  void listenToAddressNotifier(String address, LatLng latLng) {
    _address = address;
    _latLng = latLng;
    notifyListeners();
  }
}

final addressProvider = ChangeNotifierProvider(
  (_) => AddressNotifier(),
);
