import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/services/authService.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authServiceProvider = Provider<AuthenticationService>(
  (ref) => AuthenticationService(
    ref.read(firebaseAuthProvider),
  ),
);

final authStateProvider = StreamProvider<User>(
  (ref) => ref.watch(authServiceProvider).authStateChange,
);
