import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/services/registerDetailsService.dart';

class RegisterDetailsNotifier extends ChangeNotifier {
  int _phone;

  int get phone => _phone;

  void listenToRegisterDetailsNotifier(int phone) {
    _phone = phone;
    notifyListeners();
  }
}

final registerProvider = ChangeNotifierProvider(
  (_) => RegisterDetailsNotifier(),
);

final registerDetailsProvider = Provider<RegisterDetailsToFirebase>(
  (_) => RegisterDetailsToFirebase(),
);

final getRegisterDetailsProvider = StreamProvider.autoDispose<DocumentSnapshot>(
  (_) => RegisterDetailsToFirebase().viewUserDetails(),
);
