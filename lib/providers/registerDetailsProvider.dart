import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/services/registerDetailsService.dart';

class RegisterDetailsNotifier extends ChangeNotifier {
  int _phone;
  String _role, _orgName;

  int get phone => _phone;

  String get role => _role;

  String get orgName => _orgName;

  void listenToRegisterDetailsNotifier(int phone) {
    _phone = phone;
    notifyListeners();
  }

  void listenToRegisterDetailsRoleNotifier(String role) {
    _role = role;
    notifyListeners();
  }

  void listenToRegisterDetailsOrgNotifier(String orgName) {
    _orgName = orgName;
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
