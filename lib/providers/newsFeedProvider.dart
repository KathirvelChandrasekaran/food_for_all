import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_for_all/services/newsFeedService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final getNewsFeeds = StreamProvider<QuerySnapshot>(
  (_) => NewsFeedService().getPosts(),
);
