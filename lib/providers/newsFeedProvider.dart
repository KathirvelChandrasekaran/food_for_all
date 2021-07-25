import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/services/newsFeedService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final getNewsFeeds = StreamProvider.autoDispose<QuerySnapshot>(
  (_) => NewsFeedService().getPosts(),
);

final getVolunteerPosts = StreamProvider.autoDispose<QuerySnapshot>(
  (_) => NewsFeedService().getVolunteerPosts(),
);

final postProvider = Provider(
  (ref) => Post(),
);

final getSinglePost =
    StreamProvider.autoDispose.family<DocumentSnapshot, String>((ref, docId) {
  final post = ref.read(postProvider);
  return post.get(docId);
});
