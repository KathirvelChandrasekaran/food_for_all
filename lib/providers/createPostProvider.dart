import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/services/createPostService.dart';

final addPostDetails = Provider<AddPostDetailsToFirebase>(
  (_) => AddPostDetailsToFirebase(),
);
